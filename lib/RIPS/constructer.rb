#variable declarations = childs

class VarDeclare
  attr_accessor(:id, :tokens, :tokenscanstart, :tokenscanstop, :value, :comment)
  attr_accessor(:line, :marker, :dependencies, :stopvar, :array_keys)
  
  def initialize(tokens = [], comment = '' )
    @id = 0
    @tokens = tokens
    @tokenscanstart = 0
    @tokenscanstop = tokens.count
    @value = ''
    @comment = comment
    @line = ''
    @marker = 0
    @dependencies = []
    @stopvar = false
    @array_keys = []
  end
end

#group vulnerable parts to one vulnerability trace
class VulnBlock
  attr_accessor(:uid, :vuln, :category, :treenodes)
  attr_accessor(:sink, :dataleakvar, :alternates)
  
  def initialize(uid = '', category = 'match', sink = '')
    @uid = uid
    @vuln = false
    @category = category
    @treenodes = []
    @sink = sink
    @dataleakvar = []
    @alternates = []
  end
end

#used to store new finds
class VulnTreeNode
  attr_accessor(:id, :value, :dependencies, :title, :name)
  attr_accessor(:marker, :lines, :filename, :children, :funcdepend)
  attr_accessor(:funcparamdepend, :foundcallee, :get, :post)
  attr_accessor(:cookie, :files, :server)
  
  def initialize (value = null)
    @id = 0
    @value = value
    @dependencies = []
    @title = ''
    @name = ''
    @marker = 0
    @lines = []
    @filename = ''
    @children = []
    @funcdepend = ''
    @funcparamdepend = null
    @foundcallee = false
  end
end

# information gathering finds
class InfoTreeNode
  attr_accessor(:value, :dependencies, :name)
  attr_accessor(:lines, :title, :filename)
  
  def initialize(value = null)
    @value = value
    @dependencies = []
    @name = ''
    @lines = []
    @title = 'File Inclusion'
    @filename = ''
  end
end

# function declaration
class FunctionDeclare
  attr_accessor(:value, :tokens, :name)
  attr_accessor(:line, :marker, :parameters)
  
  def initialize(tokens)
    @value = ''
    @tokens = tokens
    @name = ''
    @line = 0
    @marker = 0
    @parameters = []
  end
end