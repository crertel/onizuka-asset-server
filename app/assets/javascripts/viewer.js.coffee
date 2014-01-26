#
# @abstract Description
#, 'audioPlayer'
onizuka = angular.module 'onizuka', ['ui.bootstrap','ui.ace','onizukaControllers', 'onizukaDirectives']
# onizuka.config []

onizukaControllers = angular.module 'onizukaControllers', []

onizukaControllers.controller 'viewerCtrl', ($scope) ->
	# $scope.playlist1 = []
	# $scope.playlist1 = [
	# 	{
	# 		src : 'http://0.0.0.0:5000/uploads/sound_asset/asset/4/sample-1.wav'
	# 	}
	# ]


onizukaDirectives = angular.module 'onizukaDirectives', ['ngAnimate']

onizukaDirectives.directive 'maxHeight', ($window, $timeout)->
	restrict : "A"
	link: (scope, elem, attrs) ->

		maxArea = ()->
			maxHeight = $($window).height()
			# containerHeight = maxHeight - elem.offset().top
			elem.height maxHeight

		$timeout ()->
			maxArea()
		, 0

		Bacon.fromEventTarget($window, 'resize').debounce(250).onValue ()->
			maxArea()

onizukaDirectives.directive 'imageassetViewer', ->
	restrict : "A"
	scope :
		location : '@'
		assetId : '@'
	link: (scope, elem, attrs) ->
		elem.html '<img src="'+scope.location+'">'


onizukaDirectives.directive 'markupassetViewer', ->
	restrict : "A"
	template : "<div max-height onizuka-ace></div>"
	scope :
		location : '@'
		assetId : '@'
	link: (scope, elem, attrs) ->
		$http.get(scope.location).success (data)->
			scope.data = data


onizukaDirectives.directive 'scriptassetViewer', ($http)->
	restrict : "A"
	template : "<div max-height onizuka-ace></div>"
	scope :
		location : '@'
		assetId : '@'
	link: (scope, elem, attrs) ->
		$http.get(scope.location).success (data)->
			scope.file_data = data


onizukaDirectives.directive 'onizukaAce', ->
	restrict : "A"
	template : "<div ui-ace='{onLoad: aceLoaded, mode : mode}'></div>"
	controller : ($scope) ->
		modes = 
			'lua' : 'lua'
			'frag': 'glsl'
			'glsl': 'glsl'
			'vert': 'glsl'
			'js'  : 'javascript'
			'json': 'json'
			'html': 'html'
			'css' : 'css'
			'rb'  : 'ruby'

		$scope.mode = modes[$scope.location.split('.').pop()]

		$scope.aceLoaded = (_editor)->
			$scope.editor = _editor

		$scope.$watch 'file_data', (file_data)->
			$scope.editor.setValue file_data
			$scope.editor.clearSelection()


onizukaDirectives.directive 'meshassetViewer', ($timeout, $document, $window)->
	restrict : "A"
	scope :
		location : '@'
		assetId : '@'
	link: (scope, elem, attrs) ->

		container = ''
		stats = ''
		camera = ''
		scene = ''
		renderer = ''
		mouseX = 0
		mouseY = 0

		init = (viewerElement)->

			# camera
			camera = new THREE.PerspectiveCamera 45, viewerElement.width()/viewerElement.height(), 1, 2000
			camera.position.z = 100

			# scene
			scene = new THREE.Scene()

			ambient = new THREE.AmbientLight 0x101030
			directionalLight = new THREE.DirectionalLight 0xffeedd
			directionalLight.position.set 0, 0, 1

			scene.add ambient
			scene.add directionalLight

			# loading manager
			manager = new THREE.LoadingManager()
			manager.onProgress = (item, loaded, total)->

			# texture
			texture = new THREE.Texture()
			loader = new THREE.ImageLoader manager

			loader.load '/web_assets/UV_Grid_Sm.jpg', (image) ->
				texture.image = image
				texture.needsUpdate = true

			# model
			objLoader = new THREE.OBJLoader manager
			objLoader.load scope.location, (assetObject)->

				assetObject.traverse (child)->
					if child instanceof THREE.Mesh
						child.material.map = texture

				assetObject.position.y = -80
				scene.add assetObject
				console.log assetObject

			# renderer
			renderer = new THREE.WebGLRenderer()
			renderer.setSize viewerElement.width(), viewerElement.height()

			viewerElement.append renderer.domElement

			elem.on 'mousemove', ( evnt )->
				onMouseMove evnt

		onMouseMove = (evnt)->
			mouseX = (evnt.clientX - elem.width()/2) / 2
			mouseY = (evnt.clientY - elem.height()/2) / 2


		render = ()->
			camera.position.x += ( mouseX - camera.position.x ) * .05
			camera.position.y += ( - mouseY - camera.position.y ) * .05

			camera.lookAt scene.position
			renderer.render scene, camera


		animate = ()->
			requestAnimationFrame animate
			render()

		maxArea = ()->
			maxHeight = $($window).height()
			# containerHeight = maxHeight - elem.offset().top
			elem.height maxHeight

		$timeout ()->
			maxArea()
		, 500

		Bacon.fromEventTarget($window, 'resize').debounce(250).onValue ()->
			maxArea()

		$timeout ()->
			init(elem)
			animate()
		, 1100

# cheating on the sound for now
onizukaDirectives.directive 'soundassetViewer', ->
	restrict : "A"
	template : '<audio controls><source src="/uploads/sound_asset/asset/4/U2_One.ogg" type="audio/wav"></audio>'
