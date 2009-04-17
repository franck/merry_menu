module MerryMenu
  module Helper
    def render_menu(name)
              
      html = ""
      menu_html = ""
      tabs_html = ""
      
      MerryMenu::Builder.menus[name].each do |tab|
        tabs_html << render_tab(tab[:text], tab[:url])
      end
            
      render_div(tabs_html)
    end
    
    protected
  
    def render_tab(text, url)
      content_tag("li", link_to(t(text), url), :class => ("current" if current(url)))
    end
    
    def render_div(tabs_html)
      menu_html = content_tag("ul", tabs_html)
      html = content_tag("div", menu_html, :id => "adminMenu" )
    end
  
    def current(url)
      current = controller.params[:controller] == url
    end 
  end
  
  
  class Configure 
    attr_accessor :menus
    
    def initialize
      self.menus = {}
    end
        
    def configure
      menu = Menu.new
      yield menu
      self.menus[menu.name] = menu.build
    end    
  end
  
  class Menu  
    attr_accessor :tabs, :name
    
    def initialize
      self.tabs = []
    end
    
    def menu(name)
      tab = Tab.new
      yield tab
      self.tabs = tab.build
      self.name = name
    end
      
    def build
      tabs
    end
           
  end
  
  class Tab
    attr_accessor :tabs, :text, :url
    
    def initialize
      self.tabs = []
      self.text = text
      self.url = url
    end
    
    def tab(text, url)
      self.tabs << { :text => text, :url => url }
    end
     
    def build
      tabs
    end
    
  end

  Builder = Configure.new
end