package org.zerock.service;

import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardMapperTest;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Transactional
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardServiceTest {
	
	@Setter(onMethod_ = @Autowired)
	private BoardService service;

	@Test
	public void testExist() {
		log.info(service);
		assertNotNull(service);
	}
	
	@Test
	public void testGet() throws Exception {
		BoardVO board = new BoardVO(0L, "테스트 제목", "테스트 내용", "prettykara");
		
		BoardVO actual = service.get(BoardMapperTest.TEST_BNO);
		
		assertEquals(board, actual);
	}
	
	@Test
	public void testGetList() throws Exception {
		Criteria cri = new Criteria(2, 10);
		
		List<BoardVO> list = service.getListWithPaging(cri);
		
		assertThat(list.size(), is(10));
		
		list.forEach(board -> log.info(board));
	}
	
	@Test
	public void testRegister() throws Exception {
		BoardVO board = new BoardVO(0L, "새로 작성하는 글", "새로 작성하는 내용", "newbie");
		service.register(board);
		
		log.info("생성된 게시물의 번호: " + board.getBno());
		
		BoardVO actual = service.get(board.getBno());
		
		assertEquals(board, actual);
	}
	
	@Test
	public void testModify() throws Exception {
		BoardVO board = new BoardVO(BoardMapperTest.TEST_BNO, "수정하는 글", "수정하는 내용", "newbie");
		
		assertTrue(service.modify(board));
		
		BoardVO actual = service.get(BoardMapperTest.TEST_BNO);
		
		assertEquals(board, actual);
	}
	
//	@Test
//	public void testDelete() throws Exception {
//		assertTrue(service.remove(BoardMapperTest.TEST_BNO));
//		assertNull(service.get(BoardMapperTest.TEST_BNO));
//		
//	}

}
