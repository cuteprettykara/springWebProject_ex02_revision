package org.zerock.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
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
	public void register() {
	}
	
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("register: " + board);
		
		if (service.register(board)) {
			rttr.addFlashAttribute("result", board.getBno());
		}
		
		return "redirect:/board/list";
	}
	
	@PostMapping("/modify")
	public String modify(
			BoardVO board, 
			Criteria cri,
			RedirectAttributes rttr) {
		log.info("modify: " + board);
		
		if (service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}
		
		rttr.addAttribute("page", cri.getPage());
		rttr.addAttribute("perPageNum", cri.getPerPageNum());
		rttr.addAttribute("searchType", cri.getSearchType());
		rttr.addAttribute("keyword", cri.getKeyword());

		return "redirect:/board/list";
	}
	
	@PostMapping("/remove")
	public String remove(
			@RequestParam("bno") Long bno, 
			Criteria cri,
			RedirectAttributes rttr) {
		log.info("remove: " + bno);
		
		if (service.remove(bno)) {
			rttr.addFlashAttribute("result", "success");
		}
		
		rttr.addAttribute("page", cri.getPage());
		rttr.addAttribute("perPageNum", cri.getPerPageNum());
		rttr.addAttribute("searchType", cri.getSearchType());
		rttr.addAttribute("keyword", cri.getKeyword());
		
		return "redirect:/board/list";
	}
}
