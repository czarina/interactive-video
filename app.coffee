# Made with Framer
# by Todd Hamilton
# www.toddham.com

# stack of scene indices
history = [0]

# timestamps of scene starts in seconds
sceneStarts = [0,	29,	50.9,	70,	91,	134,	164.7,	198,	239.5,	262,	288.5,	304.75,	323.75,	344.9,	360,	375.75,	392.75,	415.75,	436.5,	455.2,	468.75,	489.8,	509,	538.4,	571.75,	599,	607]

# choice button coords [button left: [[xMin, xMax], [yMin, yMax]], button right: ...]
normalChooseCoords = [[[75, 600], [350, 550]], [[750, 1250], [350, 550]]]
tallChooseCoords = [[[75, 600], [350, 650]], [[750, 1250], [350, 650]]]
naChooseCoords = [[[-1, -1], [-1, -1]], [[-1, -1], [-1, -1]]]

# which scene links to which scene 
# [[0's left scene #, 0's right scene #], [1's left scene #, 1's right scene #],....]
sceneLinks = [[1, 9], [2, 20], [5, 3], [4, 7], [25, 0], [6, 8], [25, 0], [25, 0], [25, 0], [10, 16], [11, 14], [12, 13], [25, 0], [25, 0], [15, 19], [25, 0], [18, 17], [25, 0], [25, 0], [25, 0], [21, 22], [4, 7], [23, 24], [25, 0], [25, 0]]

# choose button coords for all scenes
chooseCoords = [
	normalChooseCoords,
	tallChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	tallChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	tallChooseCoords,
	normalChooseCoords,
	tallChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	naChooseCoords
]
# nextStepScenes [[leftScene, rightScene], ...]

#time given for the choice in seconds
choiceTimer = 10

# setup a container to hold everything
videoContainer = new Layer
	width: 1360
	height: 760
	backgroundColor: '#fff'
	shadowBlur: 2
	shadowColor: 'rgba(0,0,0,0.24)'

# create the video layer
videoLayer = new VideoLayer
	width: 1360
	height: 760
	video: "images/morning_edited.mp4"
	superLayer: videoContainer

videoLayer.player.setAttribute('preload', 'auto')
videoLayer.player.addEventListener "loadedmetadata", -> 
	videoLayer.player.currentTime = 0

# center everything on screen
videoContainer.center()

# force full video load 
currEnd = 0
bufferedSegs = []
# videoLayer.player.play()
# window.setInterval( -> 
# 	bufferedSegs = []
# 	if videoLayer.player.buffered.length > 0
# 		currEnd = videoLayer.player.buffered.end(0)
# 		videoLayer.player.currentTime = currEnd - 1.0
# 
# 		for buffSegment in [0...videoLayer.player.buffered.length]
# 			bufferedSegs.push([videoLayer.player.buffered.start(buffSegment),videoLayer.player.buffered.end(buffSegment)])
# 
# 		print bufferedSegs
	#print "time: ", videoLayer.player.currentTime
	#pause if user doesn't choose	
# 	if videoLayer.player.currentTime > sceneStarts[history[history.length - 1] + 1] - 1
# 		videoLayer.player.pause()
# 		playButton.image = "images/play.png"
# , 500)

# control bar to hold buttons and timeline
controlBar = new Layer
	width:400
	height:100
	backgroundColor:'rgba(0,0,0,0.75)'
	clip:false
	borderRadius:'8px'
	superLayer:videoContainer
	opacity: 1.0
	
# position control bar towards the bottom of the video
controlBar.y = videoContainer.maxY - controlBar.height
controlBar.x = videoContainer.width/2.0 - controlBar.width/2.0

# back-scene layer
backButton = new Layer
	width: 100
	height: 100
	image: 'images/back.png'
	superLayer: controlBar

# play button
playButton = new Layer
	width:100
	height:100
	image:'images/play.png'
	superLayer:controlBar

# position back-scene button to the right of play
playButton.x = backButton.maxX

# home button
homeButton = new Layer
	width: 100
	height: 100
	image: 'images/home.png'
	superLayer: controlBar

# position home button to the right of play
homeButton.x = playButton.maxX	

# skip to choice button
skipToChoiceButton = new Layer
	width: 100
	height: 100
	image: 'images/forward.png'
	superLayer: controlBar

# position skip button to the right of home
skipToChoiceButton.x = homeButton.maxX
# forward-scene layer
forwardScene = new Layer
	width: 1360
	height: 625
	#video: "images/morning.mp4"
	superLayer: videoContainer
	backgroundColor: ""

# Function to handle play/pause button
playButton.on Events.Click, ->
	if videoLayer.player.paused == true
		videoLayer.player.play()
		playButton.image = "images/pause.png"
	else
		videoLayer.player.pause()
		playButton.image = "images/play.png"

	# simple bounce effect on click
	playButton.scale = 1.15
	playButton.animate
		properties:
			scale: 1
		time: 0.1
		curve: 'spring(900,30,0)'

# helper function for figuring out if a scene choose button is being pressed
sceneChooseButtonChecker = (xCoord, yCoord) ->
	currScene = history[history.length - 1]

	chooseLeft = chooseCoords[currScene][0]
	chooseLeftX = chooseLeft[0]
	chooseLeftY = chooseLeft[1]

	chooseRight = chooseCoords[currScene][1]
	chooseRightX = chooseRight[0]
	chooseRightY = chooseRight[1]
	
	buttonPressed = false
	# logic for left button choice
	if xCoord >= chooseLeftX[0] and xCoord <= chooseLeftX[1] and yCoord >= chooseLeftY[0] and yCoord <= chooseLeftY[1]
		#print "pressed left"
		currScene = history[history.length - 1]
		#print history
		nextScene = sceneLinks[currScene][0]
		buttonPressed = true
	# logic for right button choice
	else if xCoord >= chooseRightX[0] and xCoord <= chooseRightX[1] and yCoord >= chooseRightY[0] and yCoord <= chooseRightY[1]
		#print "pressed right"
		#print history
		currScene = history[history.length - 1]
		nextScene = sceneLinks[currScene][1]
		buttonPressed = true
		
	if buttonPressed
		history.push(nextScene)
		videoLayer.player.pause()
		videoLayer.player.currentTime = sceneStarts[nextScene]
# 		print "setting time to: ", videoLayer.player.currentTime
		videoLayer.player.play()
		playButton.image = "images/pause.png"
# 			moveScenes = window.setInterval( ->
# 				if videoLayer.player.currentTime > sceneStarts[nextScene] and videoLayer.player.currentTime < sceneStarts[nextScene] + 1.0
# 					
# 					window.clearInterval(moveScenes)
# 			,100)
		
		
# Function to handle forward scene choice
forwardScene.on Events.Tap, (event) ->
	
	#print videoLayer.player.currentTime 
	xCoord = event.point.x
	yCoord = event.point.y
	#print event.point
	
	# if a click occurs while buttons are active during scene, check if a button was clicked
	if true in [Math.round(videoLayer.player.currentTime) in  [Math.round(x)-11.. Math.round(x)] for x in sceneStarts][0]
		sceneChooseButtonChecker(xCoord, yCoord)
		
	# play /pause vid if there was a tap and no choice
	# check if the player is paused
# 	if videoLayer.player.paused == true
# 		# if true call the play method on the video layer
# 		videoLayer.player.play()
# 		playButton.image = 'images/pause.png'
# 	else
# 		# else pause the video
# 		videoLayer.player.pause()
# 		playButton.image = 'images/play.png'
# 
# 	# simple bounce effect on click
# 	playButton.scale = 1.15
# 	playButton.animate
# 		properties:
# 			scale:1
# 		time:0.1
# 		curve:'spring(900,30,0)'

# Function to handle back button
backButton.on Events.Click, ->
	
	history.pop()
	if (history.length == 0)
		history.push(0)
		
	#print "history: ", history
	videoLayer.player.currentTime = sceneStarts[history[history.length - 1] + 1] - 10
	videoLayer.player.play()
	playButton.image = "images/pause.png"

	# simple bounce effect on click
	backButton.scale = 1.15
	backButton.animate
		properties:
			scale:1
		time:0.1
		curve:'spring(900,30,0)'

# Function to handle choose button
skipToChoiceButton.on Events.Click, ->
	currScene = history[history.length - 1]
	#print currScene, 
	if currScene < sceneStarts.length - 2
		videoLayer.player.currentTime = sceneStarts[currScene + 1] - 10
	else
		videoLayer.player.currentTime = sceneStarts[currScene + 1]
	videoLayer.player.play()

	# simple bounce effect on click
	skipToChoiceButton.scale = 1.15
	skipToChoiceButton.animate
		properties:
			scale:1
		time:0.1
		curve:'spring(900,30,0)'

# Function to handle home button
homeButton.on Events.Click, ->
	#print "clicked home"
	videoLayer.player.currentTime = 0
	videoLayer.player.play()
	playButton.image = "images/pause.png"
	
	# simple bounce effect on click
	skipToChoiceButton.scale = 1.15
	skipToChoiceButton.animate
		properties:
			scale:1
		time:0.1
		curve:'spring(900,30,0)'
		
	history = [0]
	
# white timeline bar
# timeline = new Layer
# 	width:455
# 	height:10
# 	y:backButton.midY - 5
# 	x:backButton.maxX + 10
# 	borderRadius:'10px'
# 	backgroundColor:'#fff'
# 	clip:false
# 	#superLayer: controlBar
# 
# # progress bar to indicate elapsed time
# progress = new Layer
# 	width:0
# 	height:timeline.height
# 	borderRadius:'10px'
# 	backgroundColor:'#03A9F4'
# 	superLayer: timeline
# 
# # scrubber to change current time
# scrubber = new Layer
# 	width:18
# 	height:18
# 	y:-4
# 	borderRadius:'50%'
# 	backgroundColor:'#fff'
# 	shadowBlur:10
# 	shadowColor:'rgba(0,0,0,0.75)'
# 	superLayer: timeline
# 
# # make scrubber draggable
# scrubber.draggable.enabled = true
# 
# # limit dragging along x-axis
# scrubber.draggable.speedY = 0
# 
# # prevent scrubber from dragging outside of timeline
# scrubber.draggable.constraints =
# 	x:0
# 	y:timeline.midY
# 	width:timeline.width
# 	height:-10
# 
# # Disable dragging beyond constraints
# scrubber.draggable.overdrag = false

# Update the progress bar and scrubber AND CURR/LAST SCENE as video plays
videoLayer.player.addEventListener "timeupdate", ->
	if videoLayer.player.currentTime > sceneStarts[sceneStarts.length - 1]
		videoLayer.player.pause()
		playButton.image = "images/play.png"
	# Calculate progress bar position
# 	newPos = (timeline.width / videoLayer.player.duration) * videoLayer.player.currentTime
# 
# 	# Update progress bar and scrubber
# 	scrubber.x = newPos
# 	progress.width = newPos	+ 10

	# Update curr and last scene if scene has just switched


# Pause the video at start of drag
# scrubber.on Events.DragStart, ->
# 	videoLayer.player.pause()
# 
# # Update Video Layer to current frame when scrubber is moved
# scrubber.on Events.DragMove, ->
# 	progress.width = scrubber.x + 10
# 
# # When finished dragging set currentTime and play video
# scrubber.on Events.DragEnd, ->
# 	newTime = Utils.round(videoLayer.player.duration * (scrubber.x / timeline.width),0);
# 	videoLayer.player.currentTime = newTime
# 	videoLayer.player.play()
# 	playButton.image = "images/pause.png"
# 
