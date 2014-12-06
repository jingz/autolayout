# require "awesome_print"

module AsciiFactory
  # TODO should support self.view
  # 1. create UI
  # 2. create variable instance for the UI
  # 3. gather all UIs into view dict for constraint
  # 4. make the constaint layout ascii text
  # 5. add contraint to the root view
  def produce_ui_by_ascii(ascii)
    ascii.strip!
    ap self.view.frame
    view_dict = { "superview" => self.view }
    horizontal_layout = []

    add_margin_top = false
    add_margin_bottom = false
    add_margin_btw_row = false

    vertical = ""

    matrix = []
    row = 0
    vertical_options = {}
    ascii.split("\n").each do |line|
      horizontal_options = {}

      line.strip!
      if line.match(/^v{3}$/)
        add_margin_top = true
        next
      end
      if line.match(/^\^{3}$/)
        add_margin_bottom = true
        next
      end
      if line.match(/^\|$/)
        add_margin_btw_row = true
        next
      end

      matrix[row] = []
      list = line.scan(/\[([^\]]+)\]/).flatten
      list.each do |w|
        res = /(\w+)#(\w+)(\(.*\))?(?:@\{(.*)\})?/.match(w).to_a
        _, inst, ui_type, config, options = res
        if options
          if options.strip!
            _, v = options.match(/:v(\([^\)]*\))?/).to_a
            _, h = options.match(/:h(\([^\)]*\))?/).to_a
            # store for merge later
            vertical_options.merge! Hash[inst, v] if v
            horizontal_options.merge! Hash[inst, h] if h
          end
        end
        ui = create_ui_by_type(ui_type)
        inst_name = "@#{inst}"
        self.instance_variable_set(inst_name, ui)
        self.view.addSubview self.instance_variable_get(inst_name)
        view_dict.merge!(Hash[inst, self.instance_variable_get(inst_name)])
        matrix[row] << "[#{inst}#{config}]"
      end
      row += 1
      layout = line.gsub(/(\[((\w+)#(\w+)(\([^\]]*\))?(@\{[^\]]*)?))\]/, '[\3\5]')
      horizontal_options.each do |inst, option|
        layout.gsub!(Regexp.new(inst, "i"), "#{inst}#{option}")
      end
      horizontal_layout << layout
    end # end each line

    max = matrix.map do |row|
      row.count
    end.max

    matrix.each do |row|
      temp = nil 
      max.times do |t|
        if row[t]
          temp = row[t] 
        else
          row[t] = temp
        end
      end
    end
    # compose vertical layout
    vertical_layout = matrix.transpose.map do |row|
      t = ""
      t = "|-" if add_margin_top
      b = ""
      b = "-|" if add_margin_bottom
      layout = row.join('-')
      vertical_options.each do |inst, option|
        layout.gsub!(Regexp.new(inst, "i"), "#{inst}#{option}")
      end
      "#{t}#{layout}#{b}"
    end
    ap "vertical layout ------------------------------"
    ap vertical_layout
    ap "horizontal layout ----------------------------"
    ap horizontal_layout
    # 5. add contraint to the root view
    vertical_layout.each do |line|
      v = NSLayoutConstraint.
            constraintsWithVisualFormat "V:#{line}",
              options: 0,
              metrics: nil,
              views: view_dict

      self.view.addConstraints v
    end

    horizontal_layout.each do |line|
      v = NSLayoutConstraint.
            constraintsWithVisualFormat "H:#{line}",
              options: 0,
              metrics: nil,
              views: view_dict

      self.view.addConstraints v
    end
  end 

  def create_ui_by_type(type, options = {})
    case type
    when "textfield"
      ui = UITextField.alloc.init
      ui.translatesAutoresizingMaskIntoConstraints = false
      ui.borderStyle = UITextBorderStyleRoundedRect
      ui.placeholder = "Text Field"
    when "button"
      ui = UIButton.buttonWithType UIButtonTypeSystem
      ui.translatesAutoresizingMaskIntoConstraints = false
      ui.setTitle "Button", forState: UIControlStateNormal
    when "tableview"
      ui = UITableView.alloc.initWithFrame [[0,0], [0, 0]], style: UITableViewStylePlain
      ui.translatesAutoresizingMaskIntoConstraints = false
      ui.registerClass(UITableViewCell, forCellReuseIdentifier: "MyCells")
      ui.dataSource = self
    when "label"
      ui = UILabel.alloc.initWithFrame [[0,0], [0,0]]
      ui.translatesAutoresizingMaskIntoConstraints = false
      ui.preferredMaxLayoutWidth = 50.0
      ui.baselineAdjustment = UIBaselineAdjustmentAlignCenters
      ui.text = "Label"
    else
    end

    return ui
  end

end

# test
=begin
AsciiFactory::produce_ui_by_ascii %Q{
                      vvv
      |-[text#textfield]-[blob#textfield(==text)]-|
      |-[wbtn#button]-[xbtn#button(==wbtn)]-|
      |-[xxx#textfield]-[basic#button]-(==100)-|
        |-[tb#tableview@{ :v(==200) :h(==300) }]-|
                      ^^^
}.strip!
=end

