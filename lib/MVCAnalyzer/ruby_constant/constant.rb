# encoding: UTF-8

class Variables

	def initialize()
    @pdo_methods = ["query", "execute",
							"fetchall", "fetchcolumn",
							"fetch", "getattribute",
							"getcolumnmeta", "nextrowset",
							"rowcount", "setattribute",
							"setfetchmode", "bindcolumn",
							"bindparam", "bindvalue","prepare",
							"closecursor","columncount",
							"debugdumpparams", "errorcode",
							"errorinfo"]
							
		@pdoInstance = "new pdo"

		@dba_methods = ["dba_open", "dba_exists", "dba_close",
										"dba_fetch", "dba_firstkey", "dba_delete",
										"dba_handlers", "dba_insert", "dba_key_split", 
										"dba_list", "dba_optimize", "dba_sync", 
										"dba_replace", "dba_popen"]

		@get = "$_get"

		@post = "$_post"

		@request = "$_request"
	end 

  def getPdoMethods
    @pdo_methods
  end

  def getPdoInstance
  	@pdoInstance
  end

  def getDbaMethods
  	@dba_methods
  end

  def getGetToken
  	@get
  end

  def getPostToken
  	@post
  end

  def getRequestToken
  	@request
  end

  public :getPdoMethods,:getPdoInstance,:getDbaMethods,:getGetToken,:getPostToken,:getRequestToken
end
