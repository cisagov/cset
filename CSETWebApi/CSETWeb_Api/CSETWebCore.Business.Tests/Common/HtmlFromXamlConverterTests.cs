using CSETWebCore.Business.Common;

namespace CSETWebCore.Business.Tests.Common
{
    /// <summary>
    /// Unit tests for HtmlFromXamlConverter class.
    /// Tests XAML to HTML conversion functionality including color parsing, thickness parsing, and element conversion.
    /// </summary>
    public class HtmlFromXamlConverterTests
    {
        private readonly HtmlFromXamlConverter _converter;

        public HtmlFromXamlConverterTests()
        {
            _converter = new HtmlFromXamlConverter();
        }

        [Fact]
        public void ParseXamlColor_RemovesTransparencyValue_WhenColorStartsWithHash()
        {
            // Arrange
            var colorWithTransparency = "#FF0000FF"; // Red with transparency

            // Act
            var result = _converter.ParseXamlColor(colorWithTransparency);

            // Assert
            Assert.Equal("#0000FF", result);
        }

        [Fact]
        public void ParseXamlColor_ReturnsOriginalColor_WhenNoTransparency()
        {
            // Arrange
            var colorWithoutHash = "Red";

            // Act
            var result = _converter.ParseXamlColor(colorWithoutHash);

            // Assert
            Assert.Equal("Red", result);
        }

        [Fact]
        public void ParseXamlThickness_ReturnsOriginalValue_WhenSingleValue()
        {
            // Arrange
            var thickness = "10";

            // Act
            var result = _converter.ParseXamlThickness(thickness);

            // Assert
            Assert.Equal("10", result);
        }

        [Fact]
        public void ParseXamlThickness_ReturnsFormattedValue_WhenTwoValues()
        {
            // Arrange
            var thickness = "5,10"; // left/right, top/bottom

            // Act
            var result = _converter.ParseXamlThickness(thickness);

            // Assert
            Assert.Equal("10 5", result); // CSS order: top/bottom left/right
        }

        [Fact]
        public void ParseXamlThickness_ReturnsFormattedValue_WhenFourValues()
        {
            // Arrange
            var thickness = "1,2,3,4"; // left, top, right, bottom

            // Act
            var result = _converter.ParseXamlThickness(thickness);

            // Assert
            Assert.Equal("2 3 4 1", result); // CSS order: top right bottom left
        }

        [Fact]
        public void ParseXamlThickness_CeilsDecimalValues()
        {
            // Arrange
            var thickness = "1.2,2.5,3.7,4.1";

            // Act
            var result = _converter.ParseXamlThickness(thickness);

            // Assert
            Assert.Equal("3 4 5 2", result); // All values should be ceiling-ed
        }

        [Fact]
        public void ParseXamlThickness_HandlesInvalidValues_ReturnsDefault()
        {
            // Arrange
            var thickness = "invalid,test,values,here";

            // Act
            var result = _converter.ParseXamlThickness(thickness);

            // Assert
            Assert.Equal("1 1 1 1", result); // Should default invalid values to "1"
        }

        [Fact]
        public void ConvertXamlToHtml_ThrowsException_WhenXamlStringIsEmpty()
        {
            // Arrange
            var xamlString = "";

            // Act & Assert
            Assert.Throws<System.Xml.XmlException>(() => _converter.ConvertXamlToHtml(xamlString));
        }

        [Fact]
        public void ConvertXamlToHtml_ReturnsEmpty_WhenRootElementIsNotFlowDocument()
        {
            // Arrange
            var xamlString = "<Section>Test</Section>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Equal("", result);
        }

        [Fact]
        public void ConvertXamlToHtml_ConvertsParagraphToP()
        {
            // Arrange
            var xamlString = "<FlowDocument><Paragraph>Test paragraph</Paragraph></FlowDocument>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Contains("<p>", result);
            Assert.Contains("Test paragraph", result);
            Assert.Contains("</p>", result);
        }

        [Fact]
        public void ConvertXamlToHtml_ConvertsBoldToB()
        {
            // Arrange
            var xamlString = "<FlowDocument><Paragraph><Bold>Bold text</Bold></Paragraph></FlowDocument>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Contains("<b>", result);
            Assert.Contains("Bold text", result);
            Assert.Contains("</b>", result);
        }

        [Fact]
        public void ConvertXamlToHtml_ConvertsItalicToI()
        {
            // Arrange
            var xamlString = "<FlowDocument><Paragraph><Italic>Italic text</Italic></Paragraph></FlowDocument>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Contains("<i>", result);
            Assert.Contains("Italic text", result);
            Assert.Contains("</i>", result);
        }

        [Fact]
        public void ConvertXamlToHtml_ConvertsSpanToSpan()
        {
            // Arrange
            var xamlString = "<FlowDocument><Paragraph><Span>Span text</Span></Paragraph></FlowDocument>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Contains("<span>", result);
            Assert.Contains("Span text", result);
            Assert.Contains("</span>", result);
        }

        [Fact]
        public void ConvertXamlToHtml_ConvertsSectionToDiv()
        {
            // Arrange
            var xamlString = "<FlowDocument><Section><Paragraph>Content</Paragraph></Section></FlowDocument>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Contains("<div>", result);
            Assert.Contains("<p>", result);
            Assert.Contains("Content", result);
        }

        [Fact]
        public void ConvertXamlToHtml_ConvertsTableElements()
        {
            // Arrange
            var xamlString = "<FlowDocument><Table><TableRowGroup><TableRow><TableCell>Cell</TableCell></TableRow></TableRowGroup></Table></FlowDocument>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Contains("<table>", result);
            Assert.Contains("<tbody>", result);
            Assert.Contains("<tr>", result);
            Assert.Contains("<td>", result);
            Assert.Contains("Cell", result);
        }

        [Fact]
        public void ConvertXamlToHtml_ConvertsListWithDiscMarkerToUl()
        {
            // Arrange
            var xamlString = "<FlowDocument><List MarkerStyle=\"Disc\"><ListItem><Paragraph>Item 1</Paragraph></ListItem></List></FlowDocument>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Contains("<ul>", result);
            Assert.Contains("<li>", result);
            Assert.Contains("Item 1", result);
        }

        [Fact]
        public void ConvertXamlToHtml_ConvertsListWithDecimalMarkerToOl()
        {
            // Arrange
            var xamlString = "<FlowDocument><List MarkerStyle=\"Decimal\"><ListItem><Paragraph>Item 1</Paragraph></ListItem></List></FlowDocument>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Contains("<ol>", result);
            Assert.Contains("<li>", result);
            Assert.Contains("Item 1", result);
        }

        [Fact]
        public void ConvertXamlToHtml_AppliesFontSizeStyle()
        {
            // Arrange
            var xamlString = "<FlowDocument><Paragraph FontSize=\"20\">Sized text</Paragraph></FlowDocument>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Contains("font-size:20", result);
        }

        [Fact]
        public void ConvertXamlToHtml_AppliesFontFamilyStyle()
        {
            // Arrange
            var xamlString = "<FlowDocument><Paragraph FontFamily=\"Arial\">Arial text</Paragraph></FlowDocument>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Contains("font-family:Arial", result);
        }

        [Fact]
        public void ConvertXamlToHtml_AppliesForegroundColor()
        {
            // Arrange
            var xamlString = "<FlowDocument><Paragraph Foreground=\"#FF0000FF\">Blue text</Paragraph></FlowDocument>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Contains("color:#0000FF", result);
        }

        [Fact]
        public void ConvertXamlToHtml_AppliesBackgroundColor()
        {
            // Arrange
            var xamlString = "<FlowDocument><Paragraph Background=\"#FFFF0000\">Red background</Paragraph></FlowDocument>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Contains("background-color:#FF0000", result);
        }

        [Fact]
        public void ConvertXamlToHtml_AppliesTextAlignment()
        {
            // Arrange
            var xamlString = "<FlowDocument><Paragraph TextAlignment=\"Center\">Centered</Paragraph></FlowDocument>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Contains("text-align:Center", result);
        }

        [Fact]
        public void ConvertXamlToHtml_AppliesMargin()
        {
            // Arrange
            var xamlString = "<FlowDocument><Paragraph Margin=\"10,20,30,40\">Margin test</Paragraph></FlowDocument>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Contains("margin:20 30 40 10", result);
        }

        [Fact]
        public void ConvertXamlToHtml_AppliesPadding()
        {
            // Arrange
            var xamlString = "<FlowDocument><Paragraph Padding=\"5,10,15,20\">Padding test</Paragraph></FlowDocument>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Contains("padding:10 15 20 5", result);
        }

        [Fact]
        public void ConvertXamlToHtml_AppliesTextDecoration()
        {
            // Arrange
            var xamlString = "<FlowDocument><Paragraph TextDecorations=\"Underline\">Underlined</Paragraph></FlowDocument>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Contains("text-decoration:underline", result);
        }

        [Fact]
        public void ConvertXamlToHtml_AppliesBorderStyle_WhenBorderThicknessSet()
        {
            // Arrange
            var xamlString = "<FlowDocument><Paragraph BorderThickness=\"1\">Border test</Paragraph></FlowDocument>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Contains("border-width:1", result);
            Assert.Contains("border-style:solid", result);
        }

        [Fact]
        public void ConvertXamlToHtml_AppliesBorderColor()
        {
            // Arrange
            var xamlString = "<FlowDocument><Paragraph BorderBrush=\"#FF000000\">Border color test</Paragraph></FlowDocument>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Contains("border-color:#000000", result);
            Assert.Contains("border-style:solid", result);
        }

        [Fact]
        public void ConvertXamlToHtml_AppliesColSpanAttribute()
        {
            // Arrange
            var xamlString = "<FlowDocument><Table><TableRowGroup><TableRow><TableCell ColumnSpan=\"2\">Span 2</TableCell></TableRow></TableRowGroup></Table></FlowDocument>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Contains("colspan=\"2\"", result);
        }

        [Fact]
        public void ConvertXamlToHtml_AppliesRowSpanAttribute()
        {
            // Arrange
            var xamlString = "<FlowDocument><Table><TableRowGroup><TableRow><TableCell RowSpan=\"3\">Span 3</TableCell></TableRow></TableRowGroup></Table></FlowDocument>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Contains("rowspan=\"3\"", result);
        }

        [Fact]
        public void ConvertXamlToHtml_AppliesWidth()
        {
            // Arrange
            var xamlString = "<FlowDocument><Table Width=\"500\"><TableRowGroup><TableRow><TableCell>Cell</TableCell></TableRow></TableRowGroup></Table></FlowDocument>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Contains("width:500", result);
        }

        [Fact]
        public void ConvertXamlToHtml_HandlesComplexNestedStructure()
        {
            // Arrange
            var xamlString = @"<FlowDocument>
                <Section>
                    <Paragraph FontSize=""14"" FontWeight=""Bold"">
                        <Bold>Heading</Bold>
                    </Paragraph>
                    <Paragraph>
                        Regular text with <Italic>italic</Italic> and <Bold>bold</Bold>.
                    </Paragraph>
                </Section>
            </FlowDocument>";

            // Act
            var result = _converter.ConvertXamlToHtml(xamlString);

            // Assert
            Assert.Contains("<div>", result);
            Assert.Contains("<p", result);
            Assert.Contains("font-size:14", result);
            Assert.Contains("font-weight:bold", result);
            Assert.Contains("<b>", result);
            Assert.Contains("Heading", result);
            Assert.Contains("<i>", result);
            Assert.Contains("italic", result);
        }
    }
}
