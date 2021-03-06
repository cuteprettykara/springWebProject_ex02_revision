package org.zerock.service;

import java.util.List;

import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

public interface BoardService {
	
	public BoardVO get(Long bno);

	public List<BoardVO> getListWithPaging(Criteria cri);

	public boolean register(BoardVO board);
	
	public boolean modify(BoardVO board);
	
	public boolean remove(Long bno);
	
	public int getTotalCount(Criteria cri);
	
	public List<BoardAttachVO> getAttachList(Long bno);
}
