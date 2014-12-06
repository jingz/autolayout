class DemoViewController < UIViewController
  include AsciiFactory

  def viewDidLoad
    super  

    self.view.backgroundColor = UIColor.whiteColor

    # produce_ui_by_ascii %Q{
    #                   vvv
    #   |-[ff#label@{ :h(50) }]-[text#textfield]-|
    #   |-[xx#label@{ :h(50) }]-[efst#textfield]-|
    # }
    
    produce_ui_by_ascii %Q{
                      vvv
          |-[text#textfield]-|
          |-[tb#tableview]-|
          |-[est#textfield]-|
                      ^^^
    }

    # produce_ui_by_ascii %Q{
    #                    vvv
    #   |-[text#textfield]-[xx#textfield(==text)]-|
    #   |-[tb#tableview@{ :h(==text) :v(>=10,<=superview) }]-[vvv#textfield]-|
    # }
    
  end

  def numberOfSectionsInTableView(tv)
    return 1
  end

  def tableView(tv, numberOfRowsInSection: i)
    return 20
  end

  def tableView(tv, cellForRowAtIndexPath: inp)
    cell = tv.dequeueReusableCellWithIdentifier("MyCells", forIndexPath: inp) 
    cell.textLabel.text = "#{inp.row} : Cell"
    cell
  end

end
