package org.com.service;

import java.util.Date;

import org.com.vo.MemberVO;
import org.springframework.stereotype.Service;

public interface MemberService {

	void keepLogin(String userId, String id, Date sessionLimit);

	MemberVO login(MemberVO vo);

	MemberVO checkSessionKey(String value);

	public void register(MemberVO vo);
	
//	public int totalCount(HashMap<String, Object> map);
//	
//	public void regist(MemberVO vo);
//	
//	public List<MemberVO> listAll(HashMap<String, Object> map);
//
//	public void update(MemberVO vo);
//		
//	public void delete(MemberVO vo);
//	
//	public List<MQuestionVO> qlistAll(HashMap<String, Object> map);
//	
//	public int qtotalCount(HashMap<String, Object> map);
//	
//	public void qregist(MQuestionVO vo);
//	
//	public MQuestionVO qread(int mqno);
//
//	public void qupdate(MQuestionVO vo);
//		
//	public void qdelete(MQuestionVO vo);
//		
//	public void acreat(MAnswerVO vo);
//	
//	public void achecked(MAnswerVO vo);
//	
//	public List<MAnswerVO> aread(int mqno);
//	
//	public void aupdate(MAnswerVO vo);
//		
//	public void adelete(MAnswerVO vo);
//	
//	public void adeleteall(MQuestionVO vo);
//
//	public int qzeroCount(HashMap<String, Object> map);

}
