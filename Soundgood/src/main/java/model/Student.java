package model;

import DTO.LeaseDTO;
import DTO.StudentAndInstrumentDTO;
import DTO.StudentDTO;

import java.util.ArrayList;

public class Student {
    private StudentDTO student;
    private ArrayList<LeaseDTO> activeLeases;

    public Student(StudentDTO student) {
        this.student = student;
        this.activeLeases = new ArrayList<>();
    }

    public void setLeases(ArrayList<LeaseDTO> leases) {
        this.activeLeases = leases;
    }

    public boolean isRentalAllowed() {
        return activeLeases.size() < 2;
    }

    public Lease findLease(StudentAndInstrumentDTO dto) {
        for (LeaseDTO lease : activeLeases) {
            if (lease.getInstrumentId() == dto.getInstrumentId() &&
                lease.getStudentId() == dto.getStudentId()) {
                return new Lease(lease);
            }
        }
        return null;
    }

    public StudentDTO getStudent() {
        return student;
    }

    public void setStudent(StudentDTO student) {
        this.student = student;
    }

    public ArrayList<LeaseDTO> getActiveLeases() {
        return activeLeases;
    }

    public void setActiveLeases(ArrayList<LeaseDTO> activeLeases) {
        this.activeLeases = activeLeases;
    }
}
