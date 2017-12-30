#!/usr/bin/osascript

tell application "Evernote"
	
	set setListParentTag to tag "setList"
	set setListTags to every tag whose parent is equal to setListParentTag
	
	repeat with setListTag in setListTags
		set setListName to (the name of setListTag)
		set howlersNotes to find notes "tag:howlers tag:song tag:\"" & setListName & "\""
		set sortedNoteNames to sortNotes(howlersNotes) of me
		combineNotes(setListName, sortedNoteNames) of me
	end repeat
end tell


to combineNotes(setListName, sortedNoteNames)
	tell application "Evernote"
		set newTags to {"howlers", setListName}
		set setListNote to create note with html "" title "0 - Set List: " & setListName notebook "Howlers" tags newTags
		repeat with noteName in sortedNoteNames
			set notesWithName to find notes "intitle:\"" & noteName & "\""
			
			repeat with howlersNote in notesWithName
				
				set songTitle to buildTitle(howlersNote) of me
				append setListNote html songTitle
				
				set htmlContent to (the HTML content of howlersNote)
				set htmlStart to first item of (splitString(htmlContent, "<hr") of me)
				set htmlLines to rest of (splitString(htmlStart, "<div>") of me)
				repeat with htmlLine in htmlLines
					append setListNote html "<div>" & htmlLine
				end repeat
				append setListNote html "<hr>"
				
			end repeat
		end repeat
	end tell
end combineNotes

on buildTitle(howlersNote)
	tell application "Evernote"
		
		set tagsToPrint to " <span style='color: blue'>"
		
		set allTags to the tags of howlersNote
		repeat with theTag in allTags
			set tagName to (the name of theTag)
			set parentTag to (the parent of theTag)
			if parentTag is missing value then
				set parentTagName to ""
			else
				set parentTagName to (the name of parentTag)
			end if
			
			if not (parentTagName = "setlist" or parentTagName = "setlist-old" or tagName = "song" or tagName = "howlers") then
				set tagsToPrint to tagsToPrint & tagName & " "
			end if
		end repeat
		set tagsToPrint to tagsToPrint & "</span>"
		
		
		return "<h3><a style='color: black' href='" & (the note link of howlersNote) & "'>" & (the title of howlersNote) & "</a>" & tagsToPrint & "</h3>"
	end tell
end buildTitle

on sortNotes(setListNotes)
	tell application "Evernote"
		set titles to {}
		repeat with aNote in setListNotes
			set titles to titles & (the title of aNote)
		end repeat
		set sortedTitles to my simple_sort(titles)
		return sortedTitles
	end tell
end sortNotes

to splitString(aString, delimiter)
	set retVal to {}
	set prevDelimiter to AppleScript's text item delimiters
	set AppleScript's text item delimiters to {delimiter}
	set retVal to every text item of aString
	set AppleScript's text item delimiters to prevDelimiter
	return retVal
end splitString

on simple_sort(my_list)
	set the index_list to {}
	set the sorted_list to {}
	repeat (the number of items in my_list) times
		set the low_item to ""
		repeat with i from 1 to (number of items in my_list)
			if i is not in the index_list then
				set this_item to item i of my_list as text
				if the low_item is "" then
					set the low_item to this_item
					set the low_item_index to i
				else if this_item comes before the low_item then
					set the low_item to this_item
					set the low_item_index to i
				end if
			end if
		end repeat
		set the end of sorted_list to the low_item
		set the end of the index_list to the low_item_index
	end repeat
	return the sorted_list
end simple_sort

