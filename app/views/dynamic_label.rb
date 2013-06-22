class DynamicLabel < UILabel
  extend IB
  outlet :message_height_constraint

  def awakeFromNib
    removeConstraint message_height_constraint
  end

  def resizeToFit
    height = self.expectedHeight
    newFrame = self.frame
    newFrame.size.height = height
    self.setFrame(newFrame)
    return newFrame.origin.y + newFrame.size.height
  end

  def expectedHeight
    self.setNumberOfLines(0)
    self.setLineBreakMode(UILineBreakModeWordWrap)
    maximumLabelSize = CGSizeMake(self.frame.size.width,9999)
    expectedLabelSize = self.text.sizeWithFont(self.font, constrainedToSize: maximumLabelSize, lineBreakMode:self.lineBreakMode) 
    expectedLabelSize.height
  end
end
