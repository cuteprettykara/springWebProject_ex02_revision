package org.zerock.service;

import java.util.List;

import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

public interface ReplyService {
	
	public ReplyVO get(Long rno);

	public List<ReplyVO> getListWithPaging(Long bno, Criteria cri);

	public boolean register(ReplyVO reply);
	
	public boolean modify(ReplyVO reply);
	
	public boolean remove(Long rno);
	
	public int getTotalCountByBno(Long bno);
}
