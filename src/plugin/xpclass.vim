if exists("g:__XPCLASS_VIM__")
    finish
endif
let g:__XPCLASS_VIM__ = 1


let s:oldcpo = &cpo
set cpo-=< cpo+=B


fun! g:XPclass( sid, proto ) "{{{
    let clz = deepcopy( a:proto )

    let funcs = split( XPT#getCmdOutput( 'silent function /' . a:sid ), "\n" )
    call map( funcs, 'matchstr( v:val, "' . a:sid . '\\zs.*\\ze(" )' )

    for name in funcs
        if name !~ '\V\^_'
            let clz[ name ] = function( '<SNR>' . a:sid . name )
        endif
    endfor

    " wrapper
    let clz.__init__ = get( clz, 'New', function( 'g:XPclassVoidInit' ) )
    let clz.New = function( 'g:XPclassNew' )

    return clz
endfunction "}}}

fun! g:XPclassNew( ... ) dict "{{{
    let inst = copy( self )
    call call( inst.__init__, a:000, inst )
    let inst.__class__ = self
    return inst
endfunction "}}}

fun! g:XPclassVoidInit( ... ) dict "{{{
endfunction "}}}

let &cpo = s:oldcpo
