-- Raect/init.luau
-- Main entry point for RAECT framework
local Component = require(script.Component)
local createElement = require(script.createElement)
local Hooks = require(script.Hooks)

local RAECT = {
	-- Core
	Component = Component,
	PureComponent = require(script.PureComponent),
	createElement = createElement,
	createFragment = require(script.createFragment),
	createContext = require(script.createContext),
	createRef = require(script.createRef),
	forwardRef = require(script.forwardRef),

	-- Component enhancement
	memo = require(script.memo),
	lazy = require(script.lazy),

	-- Features
	Portal = require(script.Portal),
	Suspense = require(script.Suspense),
	StrictMode = require(script.StrictMode),
	ErrorBoundary = require(script.ErrorBoundary),

	-- Mounting
	mount = require(script.Reconciler).mount,
	unmount = require(script.Reconciler).unmount,
	update = require(script.Reconciler).update,

	-- Hooks
	useState = Hooks.useState,
	useReducer = Hooks.useReducer,
	useEffect = Hooks.useEffect,
	useLayoutEffect = Hooks.useLayoutEffect,
	useRef = Hooks.useRef,
	useMemo = Hooks.useMemo,
	useCallback = Hooks.useCallback,
	useContext = Hooks.useContext,
	useImperativeHandle = Hooks.useImperativeHandle,
	useId = Hooks.useId,

	-- Utilities
	Children = require(script.Children),
	findElementByClassName = require(script.findElementByClassName),
	Fragment = require(script.createFragment),

	-- Elements
	Elements = require(script.Elements),
}

return RAECT