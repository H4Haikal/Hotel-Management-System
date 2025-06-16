/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/EmptyTestNGTest.java to edit this template
 */
package hotel.management;

import static org.testng.Assert.*;
import org.testng.annotations.AfterClass;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

/**
 *
 * @author User
 */
public class AssignTaskNGTest {
    
    public AssignTaskNGTest() {
    }

    @BeforeClass
    public static void setUpClass() throws Exception {
    }

    @AfterClass
    public static void tearDownClass() throws Exception {
    }

    @BeforeMethod
    public void setUpMethod() throws Exception {
    }

    @AfterMethod
    public void tearDownMethod() throws Exception {
    }

    /**
     * Test of getStaffID method, of class AssignTask.
     */
    @Test
    public void testGetStaffID() {
        System.out.println("getStaffID");
        AssignTask instance = new AssignTask();
        int expResult = 0;
        int result = instance.getStaffID();
        assertEquals(result, expResult);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of setStaffID method, of class AssignTask.
     */
    @Test
    public void testSetStaffID() {
        System.out.println("setStaffID");
        int staffID = 0;
        AssignTask instance = new AssignTask();
        instance.setStaffID(staffID);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of getAssignmentID method, of class AssignTask.
     */
    @Test
    public void testGetAssignmentID() {
        System.out.println("getAssignmentID");
        AssignTask instance = new AssignTask();
        int expResult = 0;
        int result = instance.getAssignmentID();
        assertEquals(result, expResult);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of setAssignmentID method, of class AssignTask.
     */
    @Test
    public void testSetAssignmentID() {
        System.out.println("setAssignmentID");
        int assignmentID = 0;
        AssignTask instance = new AssignTask();
        instance.setAssignmentID(assignmentID);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of getTaskName method, of class AssignTask.
     */
    @Test
    public void testGetTaskName() {
        System.out.println("getTaskName");
        AssignTask instance = new AssignTask();
        String expResult = "";
        String result = instance.getTaskName();
        assertEquals(result, expResult);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of setTaskName method, of class AssignTask.
     */
    @Test
    public void testSetTaskName() {
        System.out.println("setTaskName");
        String taskName = "";
        AssignTask instance = new AssignTask();
        instance.setTaskName(taskName);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of getRoomNo method, of class AssignTask.
     */
    @Test
    public void testGetRoomNo() {
        System.out.println("getRoomNo");
        AssignTask instance = new AssignTask();
        int expResult = 0;
        int result = instance.getRoomNo();
        assertEquals(result, expResult);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of setRoomNo method, of class AssignTask.
     */
    @Test
    public void testSetRoomNo() {
        System.out.println("setRoomNo");
        int roomNo = 0;
        AssignTask instance = new AssignTask();
        instance.setRoomNo(roomNo);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of getStatus method, of class AssignTask.
     */
    @Test
    public void testGetStatus() {
        System.out.println("getStatus");
        AssignTask instance = new AssignTask();
        String expResult = "";
        String result = instance.getStatus();
        assertEquals(result, expResult);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of setStatus method, of class AssignTask.
     */
    @Test
    public void testSetStatus() {
        System.out.println("setStatus");
        String status = "";
        AssignTask instance = new AssignTask();
        instance.setStatus(status);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }
    
}
