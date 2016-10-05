#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on Mon Sep 26 20:41:56 2016

Requires packages gspread, oauth2client, pyopenssl, lxml

@author: lprisan.itd@gmail.com (the credentials are generated with this user)
"""
import os
import gspread
import re
from oauth2client.service_account import ServiceAccountCredentials
import sys
from lxml import etree
from subprocess import call

#print 'Number of arguments:', len(sys.argv), 'arguments.'
#print 'Argument List:', str(sys.argv)

# Some constants for the program to work
SPREADSHEET_URL_EN = "https://docs.google.com/spreadsheets/d/17aQHUptQw1W779G23sNhume_IS5h2TMmsOJVh2vo4B0/edit#gid=0"
SPREADSHEET_URL_IT = ""
TEMPLATE_DIGITAL = "./templates/digital_card_template.svg"
TEMPLATE_PRINT_FRONT = "./templates/printable_card_template_front.svg"
TEMPLATE_PRINT_BACK_PLAIN = "./templates/printable_card_template_back_plain.svg"
TEMPLATE_PRINT_BACK_TABLE = "./templates/printable_card_template_back_table.svg"
iconfiles = {'Technique': '../../icons/technique.png',
             'Task': '../../icons/task.png',
             'Team': '../../icons/team.png',
             'Technology': '../../icons/technology.png',
             'Wildcard': '../../icons/joker.png'}
bgcolors = {'Technique': '#adcdea',
            'Wildcard': '#ffffff',
            'Task': '#f57d86', # Originally '#f14c58', but looked too dark
            'Team': '#fee964',
            'Technology': '#9edb96'}
TEMPLATE_BGCOLOR = '#adcdea' #Needed to substitute the background colors in the svg



def extractFromSpreadsheet(url):
    """Connects to a (authorized) google spreadsheet, and extracts the data 
    from it about the card titles, descriptions, types etc.

    Returns list of dictionaries, each one with the card's data."""
    # If using oauth2client 2.0+
    print('Trying to connect to '+url)
    scope = ['https://spreadsheets.google.com/feeds']
    credentials = ServiceAccountCredentials.from_json_keyfile_name('Remote-GSpreadsheet-Access-25f314b90a7f.json', scope)
    gsc = gspread.authorize(credentials)
    wks = gsc.open_by_url(SPREADSHEET_URL_EN).sheet1
    #cells = wks.range('A1:F3')
    cardinstances = [] # Here we'll store the cards from the spreadsheet
    i = 2
    while True:
        print('Extracting row %d' % i)        
        rowvals = wks.row_values(i)
        #print(rowvals)
        cardtype = rowvals[0]
        if(len(cardtype)==0): #When a card has no type, we have finished
            break
        else:
            cardtitle = rowvals[1]
            carddesc = rowvals[2]
            cardind_plain = rowvals[3]
            cardind_task1 = rowvals[4]
            cardind_team1 = rowvals[5]
            cardind_tech1 = rowvals[6]
            cardind_time1 = rowvals[7]
            cardind_task2 = rowvals[8]
            cardind_team2 = rowvals[9]
            cardind_tech2 = rowvals[10]
            cardind_time2 = rowvals[11]
            cardind_task3 = rowvals[12]
            cardind_team3 = rowvals[13]
            cardind_tech3 = rowvals[14]
            cardind_time3 = rowvals[15]
            cardtags = filter(None, rowvals[16:35]) # May be multiple instances, we should check a long array and keep only the nonempty rows
            for j in range(0,len(cardtags)): # For each tag, we create a quasi-identical card instance
                card = {}
                card['type'] = cardtype
                card['title'] = cardtitle
                card['description'] = carddesc
                card['ind_plain'] = cardind_plain
                card['ind_task1'] = cardind_task1
                card['ind_team1'] = cardind_team1
                card['ind_tech1'] = cardind_tech1
                card['ind_time1'] = cardind_time1
                card['ind_task2'] = cardind_task2
                card['ind_team2'] = cardind_team2
                card['ind_tech2'] = cardind_tech2
                card['ind_time2'] = cardind_time2
                card['ind_task3'] = cardind_task3
                card['ind_team3'] = cardind_team3
                card['ind_tech3'] = cardind_tech3
                card['ind_time3'] = cardind_time3
                card['tag'] = int(cardtags[j])
                cardinstances.append(card)
                #print('Adding new card, now %d' % len(cardinstances))                
            i = i+1
    return cardinstances



def loadModifyDigitalSVG(svgfile, card):
    """Loads a digital card svg file, and loads it with the data from a card
    dictionary.

    Returns an element tree (lxml) of the modified svg file."""    # Generate the digital card
    tree = etree.parse(svgfile)
    # Modify bg color
    bgrect = tree.xpath('.//*[local-name()="rect"]')[0]
    bgrect.attrib['style'] = bgrect.attrib['style'].replace(TEMPLATE_BGCOLOR,bgcolors[card['type']])
    #nsmap = tree.getroot().nsmap.copy()
    #nsmap['xmlns'] = nsmap.pop(None)
    # bgrect = tree.xpath('.//xmlns:rect', namespaces=nsmap)[0]
    # Modify icon
    icon = tree.xpath('.//*[local-name()="image"]')[0]
    icon.attrib['{http://www.w3.org/1999/xlink}href'] = iconfiles[card['type']]
    # Modify type
    typetext = tree.xpath('.//*[@id="tspan3879"]')[0]
    typetext.text = card['type']
    # Modify title
    titletext = tree.xpath('.//*[@id="flowPara3895"]')[0]
    titletext.text = card['title']
    return tree



def getCutIndex(text):
    """Decides where to cut a long text, looking for periods in the vicinity of
    270-275 characters.
    
    Returns the index of the cut-point period"""
    if(len(text)<276 or text.find(".")==-1):
        # Short strings or strings without period, we do not cut
        return -1
    else:
        idx = text.find(".",269,276)
        if(idx==-1): 
            # Did not find period in the range, try to find the nearest one
            indexes = [m.start() for m in re.finditer('\.', text)]
            idx = min(indexes, key=lambda x:abs(x-272))
            if(idx==len(text)-1):
                return -1 # If the period is just the last character, we are not actually breaking it
            else:
                return idx
        else:
            # Found the period in the range, this is the right index!
            if(idx==len(text)-1):
                return -1 # If the period is just the last character, we are not actually breaking it
            else:
                return idx
                


def loadModifyFrontSVG(svgfile, card):
    """Loads a printable front card svg file, and loads it with the data from a card
    dictionary.

    Returns an element tree (lxml) of the modified svg file."""    # Generate the digital card
    tree = etree.parse(svgfile)
    # Modify bg color
    bgrect = tree.xpath('.//*[@id="rect3862"]')[0]
    bgrect.attrib['style'] = bgrect.attrib['style'].replace(TEMPLATE_BGCOLOR,bgcolors[card['type']])
    #nsmap = tree.getroot().nsmap.copy()
    #nsmap['xmlns'] = nsmap.pop(None)
    # bgrect = tree.xpath('.//xmlns:rect', namespaces=nsmap)[0]
    # Modify icons
    icon = tree.xpath('.//*[@id="image3933"]')[0]
    icon.attrib['{http://www.w3.org/1999/xlink}href'] = iconfiles[card['type']]
    icon2 = tree.xpath('.//*[@id="image3933-6"]')[0]
    icon2.attrib['{http://www.w3.org/1999/xlink}href'] = iconfiles[card['type']]
    # Modify tag
    tag = tree.xpath('.//*[@id="image4113"]')[0]
    tag.attrib['{http://www.w3.org/1999/xlink}href'] = '../../tags/big-noborder/'+str(card['tag'])+'.png'
    # Modify type
    typetext = tree.xpath('.//*[@id="tspan3946"]')[0]
    typetext.text = card['type']
    typetext2 = tree.xpath('.//*[@id="tspan3946-1"]')[0]
    typetext2.text = card['type']
    # Modify titleS
    titletext = tree.xpath('.//*[@id="flowPara3022"]')[0]
    titletext.text = card['title']
    titletext2 = tree.xpath('.//*[@id="flowPara3022-5"]')[0]
    titletext2.text = card['title']
    # Modify text paragraph
    fronttext = tree.xpath('.//*[@id="flowPara4200"]')[0]
    # Check whether we have to split the description, and at what point    
    cutIndex = getCutIndex(card['description'])
    if(cutIndex==-1): # No need to cut, hide the continues... text
        fronttext.text = card['description']
        conttext = tree.xpath('.//*[@id="tspan4118-0"]')[0]
        conttext.attrib['style'] = 'opacity:0;'+conttext.attrib['style']
    else: # We need to cut the text, here we display only the first part, until the index inclusive
        fronttext.text = card['description'][0:(cutIndex+1)]
    return tree


def loadModifyBackPlainSVG(svgfile, card):
    """Loads a printable back card svg file (plain variant), and loads it with 
    the data from a card dictionary.

    Returns an element tree (lxml) of the modified svg file."""    # Generate the digital card
    tree = etree.parse(svgfile)
    # Modify bg color
    bgrect = tree.xpath('.//*[@id="rect3862"]')[0]
    bgrect.attrib['style'] = bgrect.attrib['style'].replace(TEMPLATE_BGCOLOR,bgcolors[card['type']])
    #nsmap = tree.getroot().nsmap.copy()
    #nsmap['xmlns'] = nsmap.pop(None)
    # bgrect = tree.xpath('.//xmlns:rect', namespaces=nsmap)[0]
    # Modify paragraphs... the first with only the overflow text from the front
    bcktxt = ""
    # Check whether we have to split the description, and at what point    
    cutIndex = getCutIndex(card['description'])
    if(cutIndex==-1): # No need to cut, hide the continues... text
        conttext = tree.xpath('.//*[@id="tspan4118-0"]')[0]
        conttext.attrib['style'] = 'opacity:0;'+conttext.attrib['style']
    else: # We need to cut the text, here we display only the second part
        bcktxt = card['description'][(cutIndex+1):len(card['description'])]
    textleft = tree.xpath('.//*[@id="flowPara4202-3"]')[0]
    textleft.text = bcktxt
    textright = tree.xpath('.//*[@id="flowPara4202"]')[0]
    textright.text = card['ind_plain']
    return tree


def loadModifyBackTableSVG(svgfile, card):
    """Loads a printable back card svg file (table variant), and loads it with 
    the data from a card dictionary.

    Returns an element tree (lxml) of the modified svg file."""    # Generate the digital card
    tree = etree.parse(svgfile)
    # Modify bg color
    bgrect = tree.xpath('.//*[@id="rect3862"]')[0]
    bgrect.attrib['style'] = bgrect.attrib['style'].replace(TEMPLATE_BGCOLOR,bgcolors[card['type']])
    #nsmap = tree.getroot().nsmap.copy()
    #nsmap['xmlns'] = nsmap.pop(None)
    # bgrect = tree.xpath('.//xmlns:rect', namespaces=nsmap)[0]
    # Modify paragraphs... the first with only the overflow text from the front
    bcktxt = ""
    # Check whether we have to split the description, and at what point    
    cutIndex = getCutIndex(card['description'])
    if(cutIndex==-1): # No need to cut, hide the continues... text
        conttext = tree.xpath('.//*[@id="tspan4118-0"]')[0]
        conttext.attrib['style'] = 'opacity:0;'+conttext.attrib['style']
    else: # We need to cut the text, here we display only the second part
        bcktxt = card['description'][(cutIndex+1):len(card['description'])]
    textleft = tree.xpath('.//*[@id="flowPara4202-3"]')[0]
    textleft.text = bcktxt
    task1 = tree.xpath('.//*[@id="flowPara4077"]')[0]
    task1.text = card['ind_task1']
    team1 = tree.xpath('.//*[@id="flowPara4198"]')[0]
    team1.text = card['ind_team1']
    tech1 = tree.xpath('.//*[@id="flowPara4198-36"]')[0]
    tech1.text = card['ind_tech1']
    time1 = tree.xpath('.//*[@id="flowPara4198-5"]')[0]
    time1.text = card['ind_time1']
    task2 = tree.xpath('.//*[@id="flowPara4077-6"]')[0]
    task2.text = card['ind_task2']
    team2 = tree.xpath('.//*[@id="flowPara4198-3"]')[0]
    team2.text = card['ind_team2']
    tech2 = tree.xpath('.//*[@id="flowPara4198-3-1"]')[0]
    tech2.text = card['ind_tech2']
    time2 = tree.xpath('.//*[@id="flowPara4198-3-7"]')[0]
    time2.text = card['ind_time2']
    task3 = tree.xpath('.//*[@id="flowPara4077-6-2"]')[0]
    task3.text = card['ind_task3']
    team3 = tree.xpath('.//*[@id="flowPara4198-3-2"]')[0]
    team3.text = card['ind_team3']
    tech3 = tree.xpath('.//*[@id="flowPara4198-3-2-8"]')[0]
    tech3.text = card['ind_tech3']
    time3 = tree.xpath('.//*[@id="flowPara4198-3-2-5"]')[0]
    time3.text = card['ind_time3']
    return tree


# MAIN PROGRAM
if __name__ == '__main__':
    # If no args, or the first arg is --en, we do the cards from the english spreadsheet 
    cardinstances = [] # Here we'll store the cards from the spreadsheet
    if(len(sys.argv)==1 or sys.argv[1]=='--en'):
        cardinstances = extractFromSpreadsheet(SPREADSHEET_URL_EN)
    elif(sys.argv[1]=="--it"):
        cardinstances = extractFromSpreadsheet(SPREADSHEET_URL_IT)
    print('Read %d cards from spreadsheet' % len(cardinstances))
    dir_path = os.path.dirname(os.path.realpath(__file__)) # This script's path
    os.chdir(dir_path)
    print('Working in '+dir_path)
    #print(cardinstances)
    # For each card, we generate everything
    for card in cardinstances:
        digitalsvg = loadModifyDigitalSVG(TEMPLATE_DIGITAL, card)
        # write the modified file to a SVG file
        filenameD = './output/digital/'+card['title'].replace(" ","_")+'_'+str(card['tag'])+'_DIGITAL.svg'
        print('Saving digital card at '+filenameD)
        digitalsvg.write(filenameD)
        # Export the file to png for uploading in tabloro
        call(["inkscape", filenameD, "--export-png="+filenameD+".png", "-h140"]) # Should be 100x140 max
        frontsvg = loadModifyFrontSVG(TEMPLATE_PRINT_FRONT, card)
        # write the modified file to a SVG file
        filenameF = './output/printable/'+card['title'].replace(" ","_")+'_'+str(card['tag'])+'_FRONT.svg'
        print('Saving front card at '+filenameF)
        frontsvg.write(filenameF)
        # Export the file to pdf for pasting and printing
        call(["inkscape", filenameF, "--export-pdf="+filenameF+".pdf"])
        filenamePrint = './output/printable/'+card['title'].replace(" ","_")+'_'+str(card['tag'])+'_BOTH.pdf'
        # Do the back card, depending on the type
        if(card['type']=='Technique'):
            # If a technique card, the back features a table
            backtablesvg = loadModifyBackTableSVG(TEMPLATE_PRINT_BACK_TABLE, card)
            # write the modified file to a SVG file
            filenameBT = './output/printable/'+card['title'].replace(" ","_")+'_'+str(card['tag'])+'_BACK.svg'
            print('Saving back (table) card at '+filenameBT)
            backtablesvg.write(filenameBT)
            # Export the file to pdf for pasting and printing
            call(["inkscape", filenameBT, "--export-pdf="+filenameBT+".pdf"])
            # Paste both pdfs into a single pdf
            call(["pdftk", filenameF+".pdf", filenameBT+".pdf", "cat", "output", filenamePrint])
            print("Pasted both card sides")
        else:
            # If not a technique card, the back simply features texts
            backplainsvg = loadModifyBackPlainSVG(TEMPLATE_PRINT_BACK_PLAIN, card)
            # write the modified file to a SVG file
            filenameBP = './output/printable/'+card['title'].replace(" ","_")+'_'+str(card['tag'])+'_BACK.svg'
            print('Saving back (plain) card at '+filenameBP)
            backplainsvg.write(filenameBP)
            # Export the file to pdf for pasting and printing
            call(["inkscape", filenameBP, "--export-pdf="+filenameBP+".pdf"])
            # Paste both pdfs into a single pdf
            call(["pdftk", filenameF+".pdf", filenameBP+".pdf", "cat", "output", filenamePrint])
            print("Pasted both card sides")
    print("=================================\nCard generation complete!")



# Upload the images to the platform via S3?