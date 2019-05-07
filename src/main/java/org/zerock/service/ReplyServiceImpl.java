package org.zerock.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;
import org.zerock.mapper.ReplyMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class ReplyServiceImpl implements ReplyService {

	// spring 4.3 이상에서 자동 처리
	private ReplyMapper mapper;
	
	@Override
	public ReplyVO get(Long bno) {
		return mapper.read(bno);
	}

	@Override
	public List<ReplyVO> getListWithPaging(Long bno, Criteria cri) {
		return mapper.getListWithPaging(bno, cri);
	}

	@Override
	public boolean register(ReplyVO reply) {
		log.info("register: " + reply);
		
		return mapper.insert(reply) == 1;
	}

	@Override
	public boolean modify(ReplyVO reply) {
		return mapper.update(reply) == 1;
	}

	@Override
	public boolean remove(Long bno) {
		return mapper.delete(bno) == 1;
	}

	@Override
	public int getTotalCountByBno(Long bno) {
		return mapper.getTotalCountByBno(bno);
	}

}
