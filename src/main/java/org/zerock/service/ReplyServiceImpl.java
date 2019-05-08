package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;
import org.zerock.mapper.BoardMapper;
import org.zerock.mapper.ReplyMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class ReplyServiceImpl implements ReplyService {

	@Setter(onMethod_ = @Autowired)
	private ReplyMapper mapper;
	
	@Setter(onMethod_ = @Autowired)
	private BoardMapper boardMapper;
	
	@Override
	public ReplyVO get(Long bno) {
		return mapper.read(bno);
	}

	@Override
	public List<ReplyVO> getListWithPaging(Long bno, Criteria cri) {
		return mapper.getListWithPaging(bno, cri);
	}

	@Transactional
	@Override
	public boolean register(ReplyVO reply) {
		log.info("register: " + reply);
		
		boardMapper.updateReplyCnt(reply.getBno(), +1);
		
		return mapper.insert(reply) == 1;
	}

	@Override
	public boolean modify(ReplyVO reply) {
		return mapper.update(reply) == 1;
	}

	@Transactional
	@Override
	public boolean remove(Long rno) {
		
		ReplyVO vo = mapper.read(rno);
		boardMapper.updateReplyCnt(vo.getBno(), -1);
		
		return mapper.delete(rno) == 1;
	}

	@Override
	public int getTotalCountByBno(Long bno) {
		return mapper.getTotalCountByBno(bno);
	}

}
