-- Raect/types/index.luau

export type ComponentInstance = {
	props: { [string]: any },
	state: { [string]: any },
	_isMounted: boolean,
	_instance: Instance?,
	_parent: Instance?,
	_cleanups: { () -> () },
	context: { [string]: any },

	setState: (self: ComponentInstance, partialState: { [string]: any } | ((state: { [string]: any }, props: { [string]: any }) -> { [string]: any }), callback: (() -> ())?) -> (),
	forceUpdate: (self: ComponentInstance) -> (),
	render: (self: ComponentInstance) -> any,
	init: (self: ComponentInstance, props: { [string]: any }, context: { [string]: any }?) -> (),
	didMount: (self: ComponentInstance) -> (),
	didUpdate: (self: ComponentInstance, prevProps: { [string]: any }, prevState: { [string]: any }) -> (),
	willUnmount: (self: ComponentInstance) -> (),
	shouldUpdate: (self: ComponentInstance, nextProps: { [string]: any }, nextState: { [string]: any }) -> boolean,
}

export type Element = {
	type: string | ComponentInstance,
	props: { [string]: any },
	key: string?,
	ref: { current: any }?,
	children: { Element | string | number },
}

export type Ref = {
	current: any,
}

export type Context = {
	_defaultValue: any,
	Provider: (props: { value: any, children: any }) -> Element,
	Consumer: (props: { render: (value: any) -> any }) -> Element,
}

export type FunctionComponent = (props: { [string]: any }) -> Element

return {}