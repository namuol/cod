/*
Adapted from http://stackoverflow.com/a/10708913/742156
*/
{
  <%= initializer %>
}

/* The real grammar */
start =
  lines:line* {
    var result = [],
        i;

    for (i = 0; i < lines.length; i += 1) {
      if (lines[i][0] != null) {
        result.push.apply(result, indent(lines[i][0]));
      }
      result.push(lines[i][1]);
    }
    return build(result);
  }

newline =
  '\n' {
    return '';
  }

line =
  i:indent? s:(tag / text) newline? {
    var text = '';

    switch (s.type) {
    case 'tag':
      break;
    case 'text':
      if (i == null) {
        s.text = s.text.substr(lvl);
      }
      break;
    }
    return [i, s];
  }
/ i:indent? newline {
  return [i, {type:'text', text:''}]
}

indent =
  tag_indent
/ text_indent
// blank_indent

tag_indent =
  i:" "* &_tag {
    lvl = i.length;
    return i;
  }

text_indent =
  i:" "* &(_text / newline) &{ return prev.type === 'tag' || i.length < lvl; } {
    lvl = i.length;
    return i;
  }

blank_indent =
  &newline {
    return null;
  }

identifier =
  str:[^ \n]+ {
    return str.join('');
  }

// Useful for peeking ahead without altering state:
_tag =
  '@' name:identifier ' '* value:_text? {
    var _value;
    if(!isNaN(parseFloat(value))) {
      _value = parseFloat(value);
    } else if (value === 'true') {
      _value = true;
    } else if (value === 'false') {
      _value = false;
    } else {
      _value = value;
    }

    return {type: 'tag', name: name, value: _value};
  }

tag =
  tag:_tag {
    prev = tag
    return tag;
  }

// Useful for peeking ahead without altering state:
_text =
  str:[^\n]+ {
    return str.join('');
  }

text =
  str:_text {
    prev = {type: 'text', text: str};
    return prev;
  }
