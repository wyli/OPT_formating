#import xml.etree.cElementTree as ET
from lxml import etree as ET

with open('checklist') as f:

    currentID = ''
    filecount = 0
    itemcount = 0
    for line in f:

        entry = line.split('/')
        if (len(currentID) == 0) or (currentID != entry[2][0:3]):

            filecount = filecount + 1
            root = ET.Element("annotation")
            image_dataset = ET.SubElement(root, "dataset")
            image_type = ET.SubElement(root, "type")
            image_index = ET.SubElement(root, "index")

            image_dataset.text = entry[0] # OPTdataI/II/III/IV
            image_type.text = entry[1] # Cancer/HGD/LGD
            currentID = entry[2][0:3] # [0-9]{3} index of polyp
            image_index.text = currentID 

        itemcount = itemcount + 1
        image_part = ET.SubElement(root, "part")
        image_part.text = entry[2][3:4]
        #image_part.set("name", image_part.text)
        image_rotate = ET.SubElement(root, "needRotate")
        #image_rotate.set("name", image_part.text)
        image_rotate.text = '1'

        tree = ET.ElementTree(root)
        filename = '/home/wenqili/Desktop/auntie/OPT_dataset/desc/' + image_index.text + '.xml'
        #tree.write(filename)
        tree.write(filename, pretty_print=True)

print 'total images: ' + str(filecount)
print 'total blocks: ' + str(itemcount)
