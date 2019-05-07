package org.zerock.mapper;

import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertThat;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Transactional
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ReplyMapperTest {
	
	@Setter(onMethod_ = @Autowired)
	private ReplyMapper mapper;
	
	public static final long TEST_BNO = 1L;
	public static final long TEST_RNO = 1L;
	
//	public static final long TEST_BNO2 = 269523L;

	@Test
	public void getMapper() {
		log.info(mapper);
	}
	
	@Test
	public void testInsert() {
		ReplyVO vo = new ReplyVO();
		vo.setBno(TEST_BNO);
		vo.setReplytext("댓글 테스트");
		vo.setReplyer("replyer");
		
		assertThat(mapper.insert(vo), is(1));
	}
	
	@Test
	public void testRead() throws Exception {
		ReplyVO vo = new ReplyVO();
		vo.setBno(TEST_BNO);
		vo.setRno(TEST_RNO);
		vo.setReplytext("댓글 테스트1");
		vo.setReplyer("replyer1");
		
		ReplyVO actual = mapper.read(1L);
		
		assertEquals(vo, actual);
		
		log.info("acutal: " + actual);
	}
	
	@Test
	public void testDelete() throws Exception {
		assertThat(mapper.delete(TEST_RNO), is(1));
		
		assertNull(mapper.read(TEST_RNO));
	}
	
	@Test 
	public void testUpdate() throws Exception { 
		ReplyVO vo = new ReplyVO();
		vo.setBno(TEST_BNO);
		vo.setRno(TEST_RNO);
		vo.setReplytext("댓글 update 1");
		vo.setReplyer("replyer1");
		assertThat(mapper.update(vo), is(1));
	  
		ReplyVO actual = mapper.read(TEST_RNO); 
		assertEquals(vo, actual); 
	}
	
	@Test
	public void getListWithPaging() {
		Criteria cri = new Criteria();
		
		List<ReplyVO> list = mapper.getListWithPaging(TEST_BNO, cri);
		
		assertThat(list.size(), is(1));
		
		list.forEach(reply -> log.info(reply));
	}
	
//	@Test
//	public void getListWithPaging2() {
//		Criteria cri = new Criteria(1, 10);
//		
//		List<ReplyVO> list = mapper.getListWithPaging(TEST_BNO2, cri);
//		
//		assertThat(list.size(), is(3));
//		
//		list.forEach(board -> log.info(board));
//	}
}
