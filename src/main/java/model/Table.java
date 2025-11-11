package model;

import java.util.ArrayList;
import java.util.List;

public class Table {
    private int tableId;
    private String location;
    private int capacity;
    private String status; // "available", "reserved", "occupied", "maintenance"

    public Table() {}

    public Table(int tableId, String location, int capacity, String status) {
        this.tableId = tableId;
        this.location = location;
        this.capacity = capacity;
        this.status = status;
    }

    public Table(String location, int capacity, String status) {
        this.location = location;
        this.capacity = capacity;
        this.status = status;
    }

    public int getTableId() {
        return tableId;
    }

    public void setTableId(int tableId) {
        this.tableId = tableId;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isAvailable() {
        return "available".equals(status);
    }

    public boolean isReserved() {
        return "reserved".equals(status);
    }

    public boolean isOccupied() {
        return "occupied".equals(status);
    }
}
