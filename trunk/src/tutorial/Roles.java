package tutorial;

import java.util.Hashtable;
import java.util.Map;


public class Roles  {
    public Map < String, String > getRoles()  {
       Map < String, String > roles = new Hashtable < String, String > ( 2 );
       roles.put( " EMPLOYEE " , " Employee " );
       roles.put( " MANAGER " , " Manager " );
        return roles;
   } 
} 