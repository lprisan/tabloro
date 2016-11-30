#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on Tue Nov 29 19:11:59 2016

Requires packages gspread, oauth2client, pyopenssl, lxml

@author: lprisan
"""

import os
import gspread
import re
from oauth2client.service_account import ServiceAccountCredentials
import sys
from lxml import etree
from subprocess import call
import json
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import time

#print 'Number of arguments:', len(sys.argv), 'arguments.'
#print 'Argument List:', str(sys.argv)

# Some constants for the program to work
SPREADSHEET_URL_EN = "https://docs.google.com/spreadsheets/d/17aQHUptQw1W779G23sNhume_IS5h2TMmsOJVh2vo4B0/edit#gid=0"
SPREADSHEET_URL_IT = ""

BOXNAME_EN = "COMPLETE 4TS BOX EN"
BOXNAME_IT = ""
SETUPNAME_EN = "COMPLETE 4TS SETUP EN"
SETUPNAME_IT = ""


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
                #TODELETE: Clone a few fields for compatibility with DB structure 
                card['type4ts'] = cardtype
                card['chilitags'] = [ card['tag'] ]
                cardinstances.append(card)
                #print('Adding new card, now %d' % len(cardinstances))                
            i = i+1
    return cardinstances



# MAIN PROGRAM
if __name__ == '__main__':
    # If no args, or the first arg is --en, we do the cards from the english spreadsheet 
    cardinstances = [] # Here we'll store the cards from the spreadsheet
    lang = "EN"
    if(len(sys.argv)==1 or sys.argv[1]=='--en'):
        cardinstances = extractFromSpreadsheet(SPREADSHEET_URL_EN)
    elif(sys.argv[1]=="--it"):
        cardinstances = extractFromSpreadsheet(SPREADSHEET_URL_IT)
        lang="IT"
    print('Read %d cards from spreadsheet' % len(cardinstances))
    dir_path = os.path.dirname(os.path.realpath(__file__)) # This script's path
    os.chdir(dir_path)
    print('Working in '+dir_path)
    #print(cardinstances)
    # Initialize Selenium driver and authenticate into tabloro    
    print('Starting Selenium...')
    driver = webdriver.Chrome()
    driver.get("http://localhost:3000/login")
    elem = driver.find_element_by_id("email")
    elem.clear()
    elem.send_keys("lprisan.itd@gmail.com")
    elem = driver.find_element_by_id("password")
    elem.clear()
    elem.send_keys("lppslpps")
    elem.submit()
    #elem.send_keys(Keys.RETURN)
    #assert "Python" in driver.title
    assert "capture=true" in driver.page_source
    print('Successful login!')

    # TODO: For each card, we upload the piece
    #for card in cardinstances:
    card = cardinstances[0]
    uploadtitle = (card['title']+' '+lang+' '+str(time.time())).replace("-","_").replace(".","_").replace("(","_").replace(")","_")
    filepath = dir_path+"/output/digital/"+card['title'].replace(" ","_")+'_'+str(card['tag'])+'_DIGITAL.svg.png'
    assert os.path.isfile(filepath) 
    print('Starting upload of '+uploadtitle+' from file '+filepath)
    driver.get("http://localhost:3000/pieces/new")
    elem = driver.find_element_by_id("title")
    elem.clear()
    elem.send_keys(uploadtitle)
    elem = driver.find_element_by_id("image")
    elem.clear()
    elem.send_keys(filepath)
    elem.submit() 
    # TODO: Check success and get the piece id?
    elem = driver.find_element_by_tag_name("form")
    cardid = elem.get_attribute('action')
    card['mongoid'] = cardid #TODO: clean the id!!
    cardinstances[0] = card #TODO: put the updated card info in cardinstances, for later processing
    # assert "alert-success" in driver.page_source # This does not work
    print("=================================\nCard upload complete!"+cardid)
    # TODO: For each card, add it to the box set (directly in Mongo?)
    driver.close()
