import java.io.File;

import org.springframework.test.AbstractDependencyInjectionSpringContextTests;

public class TestFilterSchemes extends
		AbstractDependencyInjectionSpringContextTests {

	public void testFileExists(){
		File filters = new File("filterschemes.xml");
		
		assertTrue(filters.exists());
	}
}
