package tutorial;

import java.util.Date;

public class Product {
    private String name;
    private double price;
    private Date dateOfProduction;
    
    public Date getDateOfProduction() {
        return dateOfProduction;
    }
    
    public void setDateOfProduction(Date dateOfProduction) {
        this.dateOfProduction = dateOfProduction;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public double getPrice() {
        return price;
    }
    
    public void setPrice(double price) {
        this.price = price;
    }    
}
