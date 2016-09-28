# -*- coding: utf-8 -*-
"""
Created on Mon Sep 26 20:41:56 2016

Requires packages gspread, oauth2client, pyopenssl

@author: lprisan.itd@gmail.com (the credentials are generated with this user)
"""

import os

os.chdir("/media/sf_shared/4ts")

# If using oauth2client <2.0+
#import json
#import gspread
#from oauth2client.client import SignedJwtAssertionCredentials
#json_key = json.load(open('Remote-GSpreadsheet-Access-25f314b90a7f.json'))
#scope = ['https://spreadsheets.google.com/feeds']
#credentials = SignedJwtAssertionCredentials(json_key['client_email'], json_key['private_key'].encode(), scope)
#gsc = gspread.authorize(credentials)


# If using oauth2client 2.0+
import gspread
from oauth2client.service_account import ServiceAccountCredentials
scope = ['https://spreadsheets.google.com/feeds']
credentials = ServiceAccountCredentials.from_json_keyfile_name('Remote-GSpreadsheet-Access-25f314b90a7f.json', scope)
gsc = gspread.authorize(credentials)

wks = gsc.open_by_url("https://docs.google.com/spreadsheets/d/17aQHUptQw1W779G23sNhume_IS5h2TMmsOJVh2vo4B0/edit#gid=0").sheet1

#cells = wks.range('A1:F3')
cardinstances = []

# For now, get only a few cells
for i in range(2,4):
    rowvals = wks.row_values(i)
    print(rowvals)
    cardtype = rowvals[0]
    cardtitle = rowvals[1]
    cardfront = rowvals[2]
    cardback_L = rowvals[3]
    cardback_R = rowvals[4]
    cardtags = filter(None, rowvals[5:25]) # May be multiple instances, we should check a long array and keep only the nonempty rows
    for j in range(0,len(cardtags)): # For each tag, we create a quasi-identical card instance
        card = {}
        card['type'] = cardtype
        card['title'] = cardtitle
        card['front'] = cardfront
        card['back_L'] = cardback_L
        card['back_R'] = cardback_R
        card['tag'] = int(cardtags[j])
        cardinstances.append(card)
    
# TODO: Manipulate the SVG/XML with the cells' contents, and save a copy
from lxml import etree

iconfiles = [{'Technique': './technique.png'}]
bgcolors = {'Technique': '#adcdea'}
TEMPLATE_BGCOLOR = '#adcdea'

# Generate the digital card
card = cardinstances[0]
tree = etree.parse('digital_card_native.svg')
# Modify bg color
bgrect = tree.xpath('.//*[local-name()="rect"]')[0]
bgrect.attrib['style'] = bgrect.attrib['style'].replace(TEMPLATE_BGCOLOR,bgcolors[card['type']])
#nsmap = tree.getroot().nsmap.copy()
#nsmap['xmlns'] = nsmap.pop(None)
# bgrect = tree.xpath('.//xmlns:rect', namespaces=nsmap)[0]
# Modify icon

# Modify type

# Modify title

# write the modified file to a SVG file
tree.write()

# Convert the SVGs to PDF or PNG, and join them for printing
from subprocess import call
call(["inkscape", "/media/sf_shared/4ts/carte_azzurre_Technique_new_oriz_native.svg", "--export-pdf=frontcard.pdf"])
call(["pdftk", "frontcard.pdf", "frontcard.pdf", "cat", "output", "doublecard.pdf"])

# Do the same for the digital version of the cards


# Upload the images to the platform via S3?