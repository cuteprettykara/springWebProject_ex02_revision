package org.zerock.mapper;

import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertThat;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardVO;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Transactional
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardMapperTest {
	
	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
	public static final long TEST_BNO = 1L;

	@Test
	public void getList() {
//		assertThat(1, is(mapper.getList().size()));
		
//		mapper.getList().forEach(board -> log.info(board));
		log.info("list size: " + mapper.getList().size());
	}
	
	@Test
	public void insert() {
		BoardVO board = new BoardVO(0L, "새로 작성하는 글", "새로 작성하는 내용", "newbie");
		
		assertThat(mapper.insert(board), is(1));
		
		log.info("board: " + board);
	}
	
	@Test
	public void insertSelectKey() {
		BoardVO board = new BoardVO(0L, "새로 작성하는 글", "새로 작성하는 내용", "newbie");
		
		assertThat(mapper.insertSelectKey(board), is(1));
		
		log.info("board: " + board);
	}
	
	@Test
	public void read() {
		BoardVO board = new BoardVO(0L, "테스트 제목", "테스트 내용", "prettykara");
		
		BoardVO actual = mapper.read(TEST_BNO);
				
		assertEquals(board, actual);
		
		log.info("actual: " + actual);
	}
	
	@Test
	public void delete() throws Exception {
		assertThat(mapper.delete(TEST_BNO), is(1));
		
		assertNull(mapper.read(TEST_BNO));
	}
	
	
	  @Test 
	  public void update() throws Exception { 
		  BoardVO board = new BoardVO(TEST_BNO, "update 제목", "update 내용", "update writer");
		  assertThat(mapper.update(board), is(1));
		  
		  BoardVO actual = mapper.read(TEST_BNO); 
		  assertEquals(board, actual); 
		  
		  log.info("board: " + board);
		  log.info("actual: " + actual);
	  }
	 
}
