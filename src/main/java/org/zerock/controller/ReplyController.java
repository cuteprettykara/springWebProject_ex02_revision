package org.zerock.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.domain.ReplyVO;
import org.zerock.service.ReplyService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/replies/*")
@AllArgsConstructor
public class ReplyController {

	private ReplyService service;
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/new", 
			consumes = "application/json",
			produces = { MediaType.TEXT_PLAIN_VALUE })
	public ResponseEntity<String> register(@RequestBody ReplyVO vo) {
		ResponseEntity<String> entity = null;
		
		log.info("ReplyVO: " + vo);
		
		if (service.register(vo)) {
			entity = new ResponseEntity<>("SUCCESS", HttpStatus.OK);			
		} else {
			entity = new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);			
		}
		
		return entity;
	}
	
	@GetMapping(value = "/pages/{bno}/{page}",
			produces = {
					MediaType.APPLICATION_XML_VALUE,
					MediaType.APPLICATION_JSON_UTF8_VALUE
			})
	public ResponseEntity<Map<String, Object>> list(
			@PathVariable("bno") Long bno,
			@PathVariable("page") int page) {
		
		Criteria cri = new Criteria(page, 10);
		log.info("cri: " + cri);
		
		PageDTO pageMaker = new PageDTO(cri, service.getTotalCountByBno(bno));
		
		Map<String, Object> map = new HashMap<>();
		map.put("pageMaker", pageMaker);
		map.put("list", service.getListWithPaging(bno, cri));
		
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	@PreAuthorize("principal.username == #vo.replyer")
	@RequestMapping(value="/{rno}", method = {RequestMethod.PUT, RequestMethod.PATCH},
			consumes = "application/json",
			produces = { MediaType.TEXT_PLAIN_VALUE }
			)
	public ResponseEntity<String> modify(
			@PathVariable("rno") Long rno,
			@RequestBody ReplyVO vo) {
		ResponseEntity<String> entity = null;
		
		vo.setRno(rno);
		
		log.info("modify: " + vo);
		log.info("replyer: " + vo.getReplyer());
		
		if (service.modify(vo)) {
			entity = new ResponseEntity<>("SUCCESS", HttpStatus.OK);
		} else {
			entity = new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		
		return entity;
	}
	
	@PreAuthorize("principal.username == #vo.replyer")
	@DeleteMapping(value="/{rno}",
			consumes = "application/json",
			produces = { MediaType.TEXT_PLAIN_VALUE }
			)
	public ResponseEntity<String> remove(
			@RequestBody ReplyVO vo,
			@PathVariable("rno") Long rno) {
		ResponseEntity<String> entity = null;
		
		log.info("remove: " + rno);
		log.info("replyer: " + vo.getReplyer());
		
		if (service.remove(rno)) {
			entity = new ResponseEntity<>("SUCCESS", HttpStatus.OK);
		} else {
			entity = new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		
		return entity;
	}
	
	@GetMapping(value="/{rno}",
			produces = { 
					MediaType.APPLICATION_XML_VALUE,
					MediaType.APPLICATION_JSON_UTF8_VALUE
	})
	public ResponseEntity<ReplyVO> get(
			@PathVariable("rno") Long rno) {
		
		log.info("get: " + rno);
		
		return new ResponseEntity<>(service.get(rno), HttpStatus.OK);
	}
}
