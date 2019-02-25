package main

import (
	"C"
	"encoding/xml"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"github.com/pebbe/util"
)

type Doc struct {
	XMLName xml.Name `xml:"http://schemas.openxmlformats.org/markup-compatibility/2006 "`
	First string `xml:"xmlns:wpc,attr"`
	Body Body `xml:"w:body"`
}

type Body struct {
	XMLName xml.Name `xml:"w:body"`
	//Bbodyname xml.Name `xml:"w:body"`
	Paragraphs [] Paragraph `xml:"w:p"`
}

type Paragraph struct {
	XMLName xml.Name `xml:"w:p"`
	//paragraphname xml.Name `xml:"w:p"`
	Text [] string  `xml: "w:r>w:t"`

}

//export decode
func decode(x *C.char) int {

	//fmt.Println(err)
	return len(C.GoString(x))
}


func main() {

	xmlFile, err := os.Open("out.xml")
	// if we os.Open returns an error then handle it
	util.CheckErr(err)
	defer xmlFile.Close()


	byteValue, _ := ioutil.ReadAll(xmlFile)

	var doc Doc
	err = xml.Unmarshal(byteValue, &doc)
	util.CheckErr(err)

	newxml, err :=xml.Marshal(doc)
	util.CheckErr(err)

	out, err := json.Marshal(doc)
	util.CheckErr(err)
	str := string(out)

	fmt.Println(string(newxml))
	fmt.Println("___________________________________________________")
	fmt.Println(str)
	fmt.Println("___________________________________________________")
	fmt.Println(string(byteValue))
}
