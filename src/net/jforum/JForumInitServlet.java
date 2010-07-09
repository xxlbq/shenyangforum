package net.jforum;

import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.sql.Connection;
import java.util.Date;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.jforum.context.JForumContext;
import net.jforum.context.RequestContext;
import net.jforum.context.ResponseContext;
import net.jforum.context.web.WebRequestContext;
import net.jforum.context.web.WebResponseContext;
import net.jforum.dao.MySQLVersionWorkarounder;
import net.jforum.exceptions.ForumStartupException;
import net.jforum.repository.BBCodeRepository;
import net.jforum.repository.BanlistRepository;
import net.jforum.repository.ModulesRepository;
import net.jforum.repository.RankingRepository;
import net.jforum.repository.SecurityRepository;
import net.jforum.repository.SmiliesRepository;
import net.jforum.repository.Tpl;
import net.jforum.util.I18n;
import net.jforum.util.bbcode.BBCodeHandler;
import net.jforum.util.preferences.ConfigKeys;
import net.jforum.util.preferences.SystemGlobals;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import freemarker.cache.FileTemplateLoader;
import freemarker.cache.MultiTemplateLoader;
import freemarker.cache.TemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.SimpleHash;
import freemarker.template.Template;

/**
 * Servlet implementation class JForumInitServlet
 */
public class JForumInitServlet extends HttpServlet {
	
	private static Logger logger = Logger.getLogger(JForumInitServlet.class);

	protected boolean debug;
	private static boolean isDatabaseUp;
	private static final long serialVersionUID = 1L;
       
	@Override
	public void init(ServletConfig config) throws ServletException {

		super.init(config);

		try {
			String appPath = config.getServletContext().getRealPath("");
			debug = "true".equals(config.getInitParameter("development"));
//			DOMConfigurator.configure(appPath + "/WEB-INF/log4j.xml");

			logger.info("Starting JForum. Debug mode is " + debug);

			ConfigLoader.startSystemglobals(appPath);
			ConfigLoader.startCacheEngine();

			// Configure the template engine
//			Configuration templateCfg = new Configuration();
			
			
//			templateCfg.setTemplateUpdateDelay(2);
//			templateCfg.setSetting("number_format", "#");
			config.getServletContext().setAttribute("number_format", "#");
//			templateCfg.setSharedVariable("startupTime", new Long(new Date().getTime()));
			
			config.getServletContext().setAttribute("startupTime",  new Long(new Date().getTime()));

			// Create the default template loader
			String defaultPath = SystemGlobals.getApplicationPath() + "/templates";
			FileTemplateLoader defaultLoader = new FileTemplateLoader(new File(defaultPath));

//			String extraTemplatePath = SystemGlobals.getValue(ConfigKeys.FREEMARKER_EXTRA_TEMPLATE_PATH);
			
//			if (StringUtils.isNotBlank(extraTemplatePath)) {
//				// An extra template path is configured, we need a MultiTemplateLoader
//				FileTemplateLoader extraLoader = new FileTemplateLoader(new File(extraTemplatePath));
//				TemplateLoader[] loaders = new TemplateLoader[] { extraLoader, defaultLoader };
//				MultiTemplateLoader multiLoader = new MultiTemplateLoader(loaders);
//				templateCfg.setTemplateLoader(multiLoader);
//			} 
//			else {
//				// An extra template path is not configured, we only need the default loader
//				templateCfg.setTemplateLoader(defaultLoader);
//			}

			ModulesRepository.init(SystemGlobals.getValue(ConfigKeys.CONFIG_DIR));

			this.loadConfigStuff();
			logger.info("I18 N  LOADED");
			
			
//			
//			if (!this.debug) {
//				templateCfg.setTemplateUpdateDelay(3600);
//			}

//			JForumExecutionContext.setTemplateConfig(templateCfg);
		}
		catch (Exception e) {
			throw new ForumStartupException("Error while starting JForum", e);
		}
	
		
		startApplication();
		
		// Start database
		isDatabaseUp = ForumStartup.startDatabase();
		
		try {
			Connection conn = DBConnection.getImplementation().getConnection();
			conn.setAutoCommit(!SystemGlobals.getBoolValue(ConfigKeys.DATABASE_USE_TRANSACTIONS));
			
			// Try to fix some MySQL problems
			MySQLVersionWorkarounder dw = new MySQLVersionWorkarounder();
			dw.handleWorkarounds(conn);
			
			// Continues loading the forum
			JForumExecutionContext ex = JForumExecutionContext.get();
			ex.setConnection(conn);
			JForumExecutionContext.set(ex);
			
			// Init general forum stuff
			ForumStartup.startForumRepository();
			RankingRepository.loadRanks();
			SmiliesRepository.loadSmilies();
			BanlistRepository.loadBanlist();
		}
		catch (Throwable e) {
            e.printStackTrace();
            throw new ForumStartupException("Error while starting jforum", e);
		}
		finally {
			JForumExecutionContext.finish();
		}
		
		
		
		logger.info("=========== JForumInitServlet =========== over  ");
	}
	
	
	protected void startApplication()
	{
		try {
			SystemGlobals.loadQueries(SystemGlobals.getValue(ConfigKeys.SQL_QUERIES_GENERIC));
			SystemGlobals.loadQueries(SystemGlobals.getValue(ConfigKeys.SQL_QUERIES_DRIVER));
			
			String filename = SystemGlobals.getValue(ConfigKeys.QUARTZ_CONFIG);
			SystemGlobals.loadAdditionalDefaults(filename);

			ConfigLoader.createLoginAuthenticator();
			ConfigLoader.loadDaoImplementation();
			ConfigLoader.listenForChanges();
			ConfigLoader.startSearchIndexer();
			ConfigLoader.startSummaryJob();
		}
		catch (Exception e) {
			throw new ForumStartupException("Error while starting JForum", e);
		}
	}
	
	
	protected void loadConfigStuff()
	{
//		ConfigLoader.loadUrlPatterns();
		I18n.load();
		logger.info("I 18 N   LOADED .");
//		Tpl.load(SystemGlobals.getValue(ConfigKeys.TEMPLATES_MAPPING));

		// BB Code
		BBCodeRepository.setBBCollection(new BBCodeHandler().parse());
	}
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public JForumInitServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	
	
	
	
	

	
}
