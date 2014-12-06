class MainViewController < UIViewController
  BUTTON_STYLES = [
    UIButtonTypeCustom,
    UIButtonTypeSystem, 
    UIButtonTypeDetailDisclosure, 
    UIButtonTypeInfoLight,
    UIButtonTypeInfoDark,
    UIButtonTypeContactAdd,
    UIButtonTypeRoundedRect
  ]

  LAYOUT = %Q{
|-[button(=100)#btn]-| 
  }.strip

  def viewDidLoad
    super 
    gen(LAYOUT)
    # self.instance_variable_set("@test", 123)
    # ap @test
    # x = 90 
    # y = 50 
    # w = 150
    # h = 20
    # BUTTON_STYLES.each do |s|
    #   btn = create_a_button(s)
    #   btn.setFrame [ [x, y], [w, h] ]
    #   y += 30

    #   self.view.addSubview btn
    # end
  end

  def gen(layout)
  end

  def create_a_button(style)
    btn = UIButton.buttonWithType style
    btn.setTitle "style : #{style}", forState: UIControlStateNormal
    btn.setTitle "Hightlighted State", forState: UIControlStateHighlighted
    btn.addTarget self, action: "touch_up_inside", forControlEvents: UIControlEventTouchUpInside
    btn.addTarget self, action: "touch_down", forControlEvents: UIControlEventTouchUpInside
    ap "button with type #{style}"
    btn
  end

  def create_an_imgage_button(img_path)
    img = UIImage.imageNamed img_path 
    btn = UIButton.buttonWithType  UIButtonTypeCustom
    btn.frame = [[100, 400], [100, 30]]
    btn.setBackgroundImage img, forState: UIControlStateNormal
  end

  def touch_down
    puts "touch down" 
  end

  def touch_up_inside
    puts "touch up inside" 
  end
end
