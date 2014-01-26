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
						# child.material.map = texture
						child.material = new THREE.MeshPhongMaterial {ambient: 0x555555, color: 0xAAAAAA, specular: 0x1111111, shininess: 200}

				assetObject.position.y = -80
				scene.add assetObject

			# renderer
			renderer = new THREE.WebGLRenderer()
			renderer.setSize viewerElement.width(), viewerElement.height()

			viewerElement.append renderer.domElement

			elem.on 'mousemove', ( evnt )->
				onMouseMove evnt

			Bacon.fromEventTarget($window, 'resize').debounce(250).onValue ()->
				maximizeViewer()

		onMouseMove = (evnt)->
			mouseX = (evnt.clientX - elem.width()/2) / 2
			mouseY = (evnt.clientY - elem.height()/2) / 2

		maximizeViewer = ()->
			camera.aspect = elem.width() / elem.height()
			camera.updateProjectionMatrix()

			renderer.setSize elem.width(), elem.height()

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


onizukaDirectives.directive 'meshassetAltViewer', ($timeout, $document, $window)->
	restrict : "A"
	scope :
		location : '@'
		assetId : '@'
	link: (scope, elem, attrs) ->

		container = ''
		stats = ''
		camera = ''
		cameraTarget = ''
		scene = ''
		renderer = ''

		init = (viewerElement)->

			# camera
			camera = new THREE.PerspectiveCamera 35, viewerElement.width()/viewerElement.height(), 1, 15
			camera.position.set 3, 0.15, 3

			cameraTarget = new THREE.Vector3 0, -0.25, 0

			# scene
			scene = new THREE.Scene()
			scene.fog = new THREE.Fog 0x72645b, 2, 15

			# ground
			plane = new THREE.Mesh new THREE.PlaneGeometry(40, 40), new THREE.MeshPhongMaterial {ambient: 0x999999, color: 0x999999, specular: 0x101010 }
			plane.rotation.x = -Math.PI/2
			plane.position.y = -0.5
			scene.add plane

			plane.receiveShadow = true




			# loading manager
			manager = new THREE.LoadingManager()
			manager.onProgress = (item, loaded, total)->
			# model
			objLoader = new THREE.OBJLoader manager
			objLoader.load scope.location, (assetObject)->

				assetObject.traverse (child)->
					if child instanceof THREE.Mesh
						child.material = new THREE.MeshPhongMaterial {ambient: 0x555555, color: 0xAAAAAA, specular: 0x1111111, shininess: 200}

				assetObject.position.y = -80
				scene.add assetObject

			# lights
			scene.add new THREE.AmbientLight 0x777777

			addShadowedLight 1, 1, 1, 0xffffff, 1.35
			addShadowedLight 0.5, 1, -1, 0xffaa00, 1

			# renderer
			renderer = new THREE.WebGLRenderer {antialias: true}
			renderer.setSize elem.width(), elem.height()

			renderer.setClearColor scene.fog.color, 1

			renderer.gammaInput = true
			renderer.gammaOutput = true

			renderer.shadowMapEnabled = true
			renderer.shadowMapCullFace = THREE.CullFaceBack

			viewerElement.append renderer.domElement

			Bacon.fromEventTarget($window, 'resize').debounce(250).onValue ()->
				maximizeViewer()

		maximizeViewer = ()->
			camera.aspect = elem.width() / elem.height()
			camera.updateProjectionMatrix()

			renderer.setSize elem.width(), elem.height()

		addShadowedLight = (x, y, z, color, intensity)->

			directionalLight = new THREE.DirectionalLight color, intensity
			directionalLight.position.set x, y, z
			scene.add directionalLight

			directionalLight.castShadow = true

			d = 1
			directionalLight.shadowCameraLeft = -d
			directionalLight.shadowCameraRight = d
			directionalLight.shadowCameraTop = d
			directionalLight.shadowCameraBottom = -d

			directionalLight.shadowCameraNear = 1
			directionalLight.shadowCameraFar = 4

			directionalLight.shadowMapWidth = 1024
			directionalLight.shadowMapHeight = 1024

			directionalLight.shadowBias = -0.005
			directionalLight.shadowDarkness = 0.15


		animate = ()->
			requestAnimationFrame animate
			render()

		render = ()->
			timer = Date.now() * 0.0005

			camera.position.x = 3 * Math.cos timer
			camera.position.z = 3 * Math.sin timer

			camera.lookAt cameraTarget

			renderer.render scene, camera


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
