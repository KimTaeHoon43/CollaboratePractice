package coma.spring.dao;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;




public class AdminDao {

	String[] boardSortArr = {"type desc , seq " , "report_count" , "writer" , "write_date"};
	String[] memberSortArr = {"id " , "report_count" , "name" , "regist_date"};
	//����
	private Connection getConnection() throws Exception {
		Context ctx = new InitialContext();
		DataSource dsa = (DataSource)ctx.lookup("java:comp/env/dbcp");
		return dsa.getConnection();

	}
	//�Խ��� �� ���� �� ���
	public int getBoardCount(int i) throws Exception {
		String sql = "select count(*) from ";
		if(i == 0) {
			sql += "(select seq from noticeboard union all select seq from qnaboard)";
		}else {
			sql += "member";
		}
		try(Connection con =this.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);
				ResultSet rs = pstat.executeQuery();){
			rs.next();
			return rs.getInt(1);
		}
	}

	// �Խñ� ���� �� ȸ���� �Ű�� ����
	public void addMemberReportCount(String table, List<String> seq) throws Exception {
		String sql ="update member set report_count=report_count+1 "
				+ "where id=(select writer from "+table+" where seq=?)";
		try (Connection con = this.getConnection();){
			try(PreparedStatement pstat = con.prepareStatement(sql);){
				for(int i = 0 ; i < seq.size() ; i++) {
					pstat.setString(1, seq.get(i));
					pstat.executeUpdate();
					pstat.clearParameters();
				}
				con.close();
			}
		}
	}
	
	//�Խ��� �� ����
	public void deleteBoard(String table , List<String> seq) throws Exception {
		String sql ="delete from "+table+" where ";
		if(table.equals("member")) {
			sql+="id=?";
		}else {
			sql+="seq=?";
		}
		try (Connection con = this.getConnection();){
			try(PreparedStatement pstat = con.prepareStatement(sql);){
				for(int i = 0 ; i < seq.size() ; i++) {
					pstat.setString(1, seq.get(i));
					pstat.executeUpdate();
					pstat.clearParameters();
				}
				con.close();
			}
		}

	}


	//�Խñ� ���� �׺� ��������(�󼼰˻� ����)
	public String getNavi(int currentPage , int sort , String domain) throws Exception{

		int recordTotalCount; 
		
		if(domain.equals("toBoard.admin")) {
			recordTotalCount = this.getBoardCount(0);
		}else {
			recordTotalCount = this.getBoardCount(1);			
		}


		int pageTotalCount = 0;

		if(recordTotalCount % Configuration.recordCountPerPage > 0) {
			pageTotalCount = recordTotalCount / Configuration.recordCountPerPage + 1;
		}
		else {
			pageTotalCount = recordTotalCount / Configuration.recordCountPerPage;
		}

		if(currentPage<1) {
			currentPage=1;
		}else if(currentPage>pageTotalCount) {
			currentPage = pageTotalCount;
		}

		int startNavi = (currentPage-1)/Configuration.naviCountPerPage*Configuration.naviCountPerPage + 1;	
		int endNavi = startNavi+(Configuration.naviCountPerPage-1);
		if(endNavi > pageTotalCount) {
			endNavi = pageTotalCount;
		}

		boolean needPrev = true;
		boolean needNext = true;

		StringBuilder sb = new StringBuilder();


		if(startNavi == 1) {
			needPrev = false;
		}

		if(endNavi == pageTotalCount){
			needNext = false;
		}

		if(needPrev) {
			sb.append("<li class=\"page-item\">");
			sb.append("<a class=\"page-link\" href=\""+domain+"?sort="+sort+"&page=" + (startNavi-1) + "\">Previous</a>"); 
			sb.append("</li>");
		}else {
			sb.append("<li class=\"page-item disabled\">");
			sb.append("<a class=\"page-link\">Previous</a>"); 
			sb.append("</li>");
		}

		for(int i= startNavi; i <=endNavi; i++) {
			if(currentPage==i) {
				sb.append("<li class=\"page-item active\" aria-current=\"page\">");
				sb.append("<span class=\"page-link\">" + i + "<span class=\"sr-only\">(current)</span></span></li>");

			}else {
				sb.append("<li class=\"page-item\">");
				sb.append("<a class=\"page-link\" href=\""+domain+"?sort="+sort+"&page="+ i +"\">" + i + "</a></li>");
			}
		}

		if(needNext) {
			sb.append("<li class=\"page-item\">");
			sb.append("<a class=\"page-link\" href=\""+domain+"?sort="+sort+"&page=" + (endNavi+1) + "\">Next</a>"); 
			sb.append("</li>");
		}else {
			sb.append("<li class=\"page-item disabled\">");
			sb.append("<a class=\"page-link\">Next</a>"); 
			sb.append("</li>");
		}

		return sb.toString();
	}

	// ��� ��� ��������
	public List<AdminMemberDto> getAllMember(int page , int memberSort) throws Exception{
		int currentPage = page;
		int recordTotalCount = this.getBoardCount(1);


		int pageTotalCount = 0;
		if(recordTotalCount % Configuration.recordCountPerPage > 0) {
			pageTotalCount = recordTotalCount/Configuration.recordCountPerPage+1;
		}else {
			pageTotalCount = recordTotalCount/Configuration.recordCountPerPage;
		}

		if(currentPage < 1) {
			currentPage = 1;
		}else if(currentPage > pageTotalCount) {
			currentPage=pageTotalCount;
		}

		int start = currentPage*Configuration.recordCountPerPage - 
				(Configuration.recordCountPerPage-1);
		int end = start + (Configuration.recordCountPerPage-1);


		String sql ="select * from "
				+ "(select member.*, row_number() "
				+ "over(order by member."+memberSortArr[memberSort]+" desc) rnum "
				+ "from member) where rnum between ? and ?";
		try (Connection con = this.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);){
			pstat.setInt(1, start);
			pstat.setInt(2, end);
			try(ResultSet rs = pstat.executeQuery();){
				List<AdminMemberDto> list = new ArrayList<>();
				while(rs.next()) {
					AdminMemberDto dto = new AdminMemberDto(rs.getString("id"),rs.getString("name")
							,rs.getString("phone"),rs.getString("email")
							,rs.getDate("regist_date"),rs.getInt("report_count"));
					list.add(dto);
				}
				con.close();
				return list;
			}			
		}
	}

	// ��� �Խ��� �� ��������
	public List<AdminBoardDto> getAllBoard(int page , int boardSort) throws Exception{
		int currentPage = page;
		int recordTotalCount = this.getBoardCount(0);


		int pageTotalCount = 0;
		if(recordTotalCount % Configuration.recordCountPerPage > 0) {
			pageTotalCount = recordTotalCount/Configuration.recordCountPerPage+1;
		}else {
			pageTotalCount = recordTotalCount/Configuration.recordCountPerPage;
		}

		if(currentPage < 1) {
			currentPage = 1;
		}else if(currentPage > pageTotalCount) {
			currentPage=pageTotalCount;
		}

		int start = currentPage*Configuration.recordCountPerPage - 
				(Configuration.recordCountPerPage-1);
		int end = start + (Configuration.recordCountPerPage-1);
		System.out.println(start);
System.out.println(end);
		String sql ="select * "
				+ "from ("
				+ "select t.*, row_number() over(order by t."+boardSortArr[boardSort]+" desc) rnum "
				+ "from ("
				+ "select '����' as type, seq , title , report_count , writer , write_date "
				+ "from noticeboard "
				+ "union all "
				+ "select '����' as type, seq , title , report_count , writer , write_date "
				+ "from qnaboard) t) "
				+ "where rnum between ? and ?";
		try (Connection con = this.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);){
			pstat.setInt(1, start);
			pstat.setInt(2, end);
			try(ResultSet rs = pstat.executeQuery();){
				List<AdminBoardDto> list = new ArrayList<>();
				while(rs.next()) {
					AdminBoardDto dto = new AdminBoardDto(rs.getString("type"),rs.getInt("seq"),rs.getString("title"),
							rs.getInt("report_count"),
							rs.getString("writer"),rs.getDate("write_date"));
					list.add(dto);
				}
				con.close();
				return list;
			}			
		}
	}


	// ������ ��������
	public void insertSite() throws Exception{
		this.deleteSite();
		Thread wevityThread1 = new Thread() {
			public void run() {
				try {new AdminDao().wevitySite("https://www.wevity.com/?c=find&s=1&gub=1&cidx=21");}
				catch(Exception e) {e.printStackTrace();}
			}		
		};
		Thread wevityThread2 = new Thread() {
			public void run() {
				try {new AdminDao().wevitySite("https://www.wevity.com/?c=find&s=1&gub=1&cidx=20");}
				catch(Exception e) {}
			}
		};
		Thread thinkThread = new Thread() {
			public void run() {
				try {new AdminDao().thinkSite();}
				catch(Exception e) {}
			}
		};
		long start = System.currentTimeMillis();
		wevityThread1.start();wevityThread2.start();thinkThread.start();

		while(wevityThread1.isAlive() || wevityThread2.isAlive()|| thinkThread.isAlive()) {
			
			Thread.sleep(300);
		}
		long end= System.currentTimeMillis();
		System.out.println(end-start);

	}

	//	//������ ����Ʈ ������ �����
	private void deleteSite() throws Exception{
		String sql = "delete from crawlingsite";
		try(Connection con = this.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);){
			pstat.executeUpdate();
		}
		System.out.println("delete done");
	}


	//	//����Ƽ ����Ʈ ũ�Ѹ�
	private void wevitySite(String siteName) throws Exception{
		System.out.println(siteName + " run");
		String sql = "insert into CrawlingSite values(?,?,?,?,?,?,?)";

		Document doc = Jsoup.connect(siteName).get();
		//�⺻ ������ ��ť��Ʈ �Է�
		Elements linkTag = doc.select("UL.list>LI>div>a");
		Elements date = doc.select("UL.list>LI>div>span");

		List<Document> link = new ArrayList<>();
		for(int i = 0 ; i < linkTag.size();i++) {
			if(!date.get(i).text().equals("����")) {
				String st = "https://www.wevity.com/" +linkTag.get(i).attr("href");
				link.add(Jsoup.connect(st).get());
				//�������� ��ť��Ʈ �Է�
			}else {break;}
		}

		try (Connection con = this.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);){

			for(int i = 0 ; i < link.size();i++) {
				Element fieldEle = link.get(i).selectFirst("ul.cd-info-list>li");
				pstat.setString(7 ,  fieldEle.text().replace("�о� ", ""));


				Element imgEle = link.get(i).selectFirst("div.thumb>img");
				pstat.setString(1 ,  ("https://www.wevity.com"+imgEle.attr("src")));

				Element titleEle = link.get(i).selectFirst("h6.tit");
				pstat.setString(2 ,  titleEle.text());

				Elements organizeEle = link.get(i).select("UL.cd-info-list>li");
				pstat.setString(3 ,  organizeEle.get(2).text().replace("����/�ְ� ", ""));

				Element periodEle = link.get(i).selectFirst("LI.dday-area");
				String[] periods = periodEle.text().split("~");
				Pattern p = Pattern.compile("\\d{4}-\\d{2}-\\d{2}");
				Matcher m1 = p.matcher(periods[0]); m1.find();
				Matcher m2 = p.matcher(periods[1]); m2.find();
				String st1 = m1.group();String st2 = m2.group();
				pstat.setString(4 ,  st1);
				pstat.setString(5 ,  st2);
				pstat.setString(6 ,  organizeEle.get(7).select("a").text());

				pstat.executeUpdate();
				pstat.clearParameters();
			}
//			con.commit();
			
			con.close();
		}
		System.out.println(siteName + " done");
	}

	//�ű� ����Ʈ ũ�Ѹ�
	private void thinkSite() throws Exception{
		System.out.println("think run");
		String sql = "insert into CrawlingSite values(?,?,?,?,?,?,?)";


		Document doc = Jsoup.connect("https://www.thinkcontest.com/Contest/CateField.html?c=12").get();
		//�⺻ ������ ��ť��Ʈ �Է�
		Elements linkTag = doc.select("TBODY>TR>TD>DIV>A");
		Elements date = doc.select("TBODY>TR>TD>SPAN");

		List<Document> link = new ArrayList<>();
		for(int i = 0 ; i < linkTag.size();i++) {
			if(!date.get(i).text().equals("����")) {
				String st = "https://www.thinkcontest.com" +linkTag.get(i).attr("href");
				link.add(Jsoup.connect(st).get());
				//�������� ��ť��Ʈ �Է�
			}else {break;}
		}

		try (Connection con = this.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);){
			for(int i = 0 ; i < link.size();i++) {
				Element imgEle = link.get(i).selectFirst("div.poster-holder>img");
				pstat.setString(1 ,  ("https://www.thinkcontest.com"+imgEle.attr("src")));

				Element titleEle = link.get(i).selectFirst("span.title");
				pstat.setString(2 ,  titleEle.text());

				Elements headEle = link.get(i).select("TBODY>TR>TH");
				Elements indexEle = link.get(i).select("TBODY>TR>TD");
				String ori = "";

				for(int j = 0 ; j < headEle.size() ; j++) {
					String el = headEle.get(j).text();			
					if(el.contentEquals("����")) {
						ori += indexEle.get(j).text();						
					}else if(el.contentEquals("�ְ�")) {
						ori += "," + indexEle.get(j).text();					
					}else if(el.contentEquals("�����Ⱓ")) {
						String[] periods = indexEle.get(j).text().split("~");
						Pattern p = Pattern.compile("\\d{4}-\\d{2}-\\d{2}");
						Matcher m1 = p.matcher(periods[0]); m1.find();
						Matcher m2 = p.matcher(periods[1]); m2.find();
						String st1 = m1.group();String st2 = m2.group();
						pstat.setString(4 ,  st1);
						pstat.setString(5 ,  st2);
					}else if(el.contentEquals("Ȩ������")) {
						pstat.setString(6 ,  indexEle.get(j).select("A").attr("href"));
					}else if(el.contentEquals("����о�")) {
						pstat.setString(7 ,  indexEle.get(j).text());
					}

				}
				pstat.setString(3 ,  ori);

				pstat.executeUpdate();
				pstat.clearParameters();
			}
//			con.commit();
			con.close();
		}
		System.out.println("think done");
	}
	// ������ ��������

}
