module MerryMenu
  module Helper
        
    def render_menu(name, options = {})
      tabs_html = ""
      menu_id_name = (options[:menu_id] || "menu").to_s
      
      current_menu = false
      
      i = 0
      MerryMenu::Builder.menus[name].each do |tab|
        position = (i == 0 ?  "first" : "")
        i += 1
        
        if tab[:roles].blank?
          tabs_html << render_tab(tab[:text], tab[:url], position)
        else
          if controller.send(:current_user).has_role? tab[:roles]
            tabs_html << render_tab(tab[:text], tab[:url], position)
          end
        end
        
        if current_controller?(tab[:url][:controller])
          current_menu = true
        end
      end
            
      current_menu ? render_div(tabs_html, menu_id_name) : render_div("", menu_id_name)
    end
    
    
    protected
  
    def render_tab(text, url, position="")
      
      class_name = []
      class_name << "current" if current_controller?(url[:controller])
      class_name << position
      
      content_tag("li", link_to(t(text), url), :class => (class_name.join(" ") if class_name.size > 0))
    end
    
    def render_div(tabs_html, menu_id_name)
      menu_html = content_tag("ul", tabs_html)
      html = content_tag("div", menu_html, :id => menu_id_name )
    end
  
    def current_controller?(ctrller)
      pattern = ctrller.gsub(/^\//, "")
      controller.params[:controller].include?(pattern)
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
    attr_accessor :tabs, :text, :url, :roles
    
    def initialize
      self.tabs = []
      self.text = text
      self.url = url
      self.roles = roles
    end
    
    def tab(text, url, roles="")
      self.tabs << { :text => text, :url => url, :roles => roles }
    end
     
    def build
      tabs
    end
    
  end

  Builder = Configure.new
end