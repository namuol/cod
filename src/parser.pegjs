/*
Adapted from http://stackoverflow.com/a/10708913/742156
*/
{
  <%= initializer %>
}

/* The real grammar */
start   = first:line tail:(newline line)* newline? { return build(first, tail); }
line    = depth:indent s:(tag / textline)          { return [depth, s]; }
indent  = s:" "*                                   { return indent(s); }
identifier = a:[^ \n]+                             { return a.join(''); }
tag     = '@' name:identifier ' '* value:text?     { return {type: 'tag', name: name, value: value}; }
textline = text:text*                              { return {type: 'text', text:text[0]}; }
text    = c:[^\n]+                                 { return c.join(''); }
newline = " "* "\n"                                {}