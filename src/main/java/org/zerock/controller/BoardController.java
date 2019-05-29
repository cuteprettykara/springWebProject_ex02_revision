package org.zerock.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {

	private BoardService service;
	
	private static final String UPLOAD_FOLDER = System.getProperty("user.home") + File.separator + "upload" + File.separator;
	
	@RequestMapping("/list")
	public void list(@ModelAttribute("cri") Criteria cri, Model model) {
		log.info("list");
		
		PageDTO pageMaker = new PageDTO(cri, service.getTotalCount(cri));
		
		model.addAttribute("list", service.getListWithPaging(cri));
		model.addAttribute("pageMaker", pageMaker);
		
		log.info("pageMaker : " + pageMaker);
	}
	
	@GetMapping({"/read", "/modify"})
	public void read(
			@RequestParam("bno") Long bno, 
			@ModelAttribute("cri") Criteria cri,
			Model model) {
		log.info("read: " + bno);
		log.info("Criteria: " + cri);
		
		model.addAttribute("board", service.get(bno));
	}
	
	@GetMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public void register() {
	}
	
	@PostMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("register: " + board);
		
		if (board.getAttachList() != null) {
			board.getAttachList().forEach(attach -> log.info(attach));
		}
		
		if (service.register(board)) {
			rttr.addFlashAttribute("result", board.getBno());
		}
		
		return "redirect:/board/list";
	}
	
	@PostMapping("/modify")
	@PreAuthorize("principal.username == #board.writer")
	public String modify(
			BoardVO board, 
			Criteria cri,
			RedirectAttributes rttr) {
		log.info("modify: " + board);
		
		if (service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}
		
		return "redirect:/board/list" + cri.getListLink();
	}
	
	@PostMapping("/remove")
	@PreAuthorize("principal.username == #writer")
	public String remove(
			@RequestParam("bno") Long bno, 
			String writer,
			Criteria cri,
			RedirectAttributes rttr) {
		log.info("remove: " + bno);
		
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		
		if (service.remove(bno)) {		// delete Attach Files in DB
			deleteFiles(attachList);	// delete Attach Files in folder.
			
			rttr.addFlashAttribute("result", "success");
		}
		
		return "redirect:/board/list" + cri.getListLink();
	}
	
	private void deleteFiles(List<BoardAttachVO> attachList) {
		if (attachList == null || attachList.size() == 0) return;
		
		log.info("delete attach files....");
		log.info(attachList);
		
		attachList.forEach(attach -> {
			
			try {
				Path file = Paths.get(UPLOAD_FOLDER + attach.getUploadPath() + File.separator 
						+ attach.getUuid() + "_" + attach.getFileName());
				
				// file을 지우기 전에 image 타입인지 아닌지를 검사한다.
				// 로컬 윈도우에서는 file을 지우고나서, Files.probeContentType(file)이 제대로 작동을 하지만,
				// ubuntu에서는 file을 지우고나면, file이 null이 되어서,
				// Files.probeContentType(file) 문장에서  NullPointerException이 떨어진다.
				boolean isImageType = Files.probeContentType(file).startsWith("image");
				
				Files.deleteIfExists(file);
				
				if (isImageType) {
					Path thumbNail = Paths.get(UPLOAD_FOLDER + attach.getUploadPath() + File.separator 
						+ "s_" + attach.getUuid() + "_" + attach.getFileName());
					
					Files.delete(thumbNail);
				}
			} catch (IOException e) {
				log.error("delete file error" + e.getMessage());
			}
		});
	}

	@GetMapping(value = "/getAttachList",
			produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno) {
		return new ResponseEntity<List<BoardAttachVO>>(service.getAttachList(bno), HttpStatus.OK);
	}
}
