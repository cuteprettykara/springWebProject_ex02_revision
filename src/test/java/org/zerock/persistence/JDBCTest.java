package org.zerock.persistence;

import static org.junit.Assert.*;

import java.sql.Connection;
import java.sql.DriverManager;

import org.junit.Test;

import lombok.extern.log4j.Log4j;

@Log4j
public class JDBCTest {
	private static final String DRIVER = "oracle.jdbc.driver.OracleDriver";
	private static final String URL = "jdbc:oracle:thin:@localhost:1521/XE";
	private static final String USER = "ZEROCK";
	private static final String PW = "ZEROCK";

	@Test
	public void testConnection() throws ClassNotFoundException {
		Class.forName(DRIVER);
		
		try (Connection con = DriverManager.getConnection(URL, USER, PW)){
			log.info(con);
		} catch (Exception e) {
			fail(e.getMessage());
		}
	}
}
