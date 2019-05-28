package org.zerock.controller;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.ArrayList;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;
import org.zerock.domain.BoardVO;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Transactional
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration({
	"file:webapp/WEB-INF/spring/root-context.xml",
	"file:webapp/WEB-INF/spring/appServlet/servlet-context.xml"
})
@Log4j
public class BoardControllerTest {
	
	@Setter(onMethod_ = @Autowired)
	private WebApplicationContext ctx;
	
	private MockMvc mockMvc;
	
	@Before
	public void setup() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	}

	@SuppressWarnings("unchecked")
	@Test
	public void testList() throws Exception {
		ArrayList<BoardVO> list =
			(ArrayList<BoardVO>) mockMvc.perform(MockMvcRequestBuilders.get("/board/list")
				.param("page", "2")
				.param("perPageNum", "10"))
			.andDo(print())
			.andReturn()
			.getModelAndView()
			.getModelMap().get("list");
		
		assertEquals(10, list.size());
	}
	
	@Test
	public void testGet() throws Exception {
		log.info(
			mockMvc.perform(MockMvcRequestBuilders.get("/board/read")
								.param("bno", "1"))
				.andReturn()
				.getModelAndView()
				.getModelMap()
		);
	}
	
//	@Test
//	public void testRegister() throws Exception {
//		Long resultMessage = 
//		(Long) mockMvc.perform(MockMvcRequestBuilders.post("/board/register")
//							.param("title", "새로 작성하는 글")
//							.param("content", "새로 작성하는 내용")
//							.param("writer", "newbie"))
//			.andDo(print())
//			.andExpect(redirectedUrl("/board/list"))
//			.andReturn()
//			.getFlashMap().get("result");
//		
//		assertNotNull(resultMessage);
//		
//		log.info("inserted bno: [" + resultMessage + "]");
//	}
	
	@Test
	public void testModifyOK() throws Exception {
		String resultMessage =
		(String) mockMvc.perform(MockMvcRequestBuilders.post("/board/modify")
							.param("bno", "1")
							.param("title", "수정된  제목")
							.param("content", "수정된 내용")
							.param("writer", "newbie"))
			.andDo(print())
			.andExpect(status().isFound())	// 302
			.andExpect(redirectedUrl("/board/list?page=1&perPageNum=10&searchType&keyword"))
			.andReturn()
			.getFlashMap().get("result");
		
		assertEquals("success", resultMessage);
	}
	
	@Test
	public void testModifyBad() throws Exception {
		String resultMessage =
		(String) mockMvc.perform(MockMvcRequestBuilders.post("/board/modify")
							.param("bno", "999999")	// 에러 상황을 유도 : 없는 bno를 넘긴다.
							.param("title", "수정된  제목")
							.param("content", "수정된 내용")
							.param("writer", "newbie"))
			.andDo(print())
			.andExpect(status().isFound())	// 302
			.andReturn()
			.getFlashMap().get("result");
		
		assertNull(resultMessage);
	}

//	@Test
//	public void testRemoveOK() throws Exception {
//		String resultMessage =
//		(String) mockMvc.perform(MockMvcRequestBuilders.post("/board/remove")
//							.param("bno", "1"))
//			.andDo(print())
//			.andExpect(status().isFound())	// 302
//			.andExpect(redirectedUrl("/board/list?page=1&perPageNum=10&searchType&keyword"))
//			.andReturn()
//			.getFlashMap().get("result");
//		
//		assertEquals("success", resultMessage);
//	}
	
	@Test
	public void testRemoveBad() throws Exception {
		String resultMessage =
		(String) mockMvc.perform(MockMvcRequestBuilders.post("/board/remove")
							.param("bno", "999999"))	// 에러 상황을 유도 : 없는 bno를 넘긴다.
			.andDo(print())
			.andExpect(status().isFound())	// 302
			.andExpect(redirectedUrl("/board/list?page=1&perPageNum=10&searchType&keyword"))
			.andReturn()
			.getFlashMap().get("result");
		
		assertNull(resultMessage);
	}
}
