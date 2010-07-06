package tutorial;

import java.util.List;

import com.opensymphony.xwork2.ActionSupport;

public class ProductConfirm extends ActionSupport {
    public List<Product> products;

    public List<Product> getProducts() {
        return products;
    }

    public void setProducts(List<Product> products) {
        this.products = products;
    }
    
    @Override
    public String execute() {
        for(Product p : products) {
            System.out.println(p.getName() + " | "+ p.getPrice() +" | " + p.getDateOfProduction());
        }
        return SUCCESS;
    }
}