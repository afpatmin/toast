import 'dart:async';
import 'dart:html' as dom;
import 'dart:svg';

import 'alert_level_properties.dart';

final int _toastMargin = 4;

class Toast {
  final AlertLevel alertLevel;
  final dom.DivElement _container = dom.DivElement();
  final dom.DivElement _content = dom.DivElement();
  final dom.DivElement _closeButton = dom.DivElement()
    ..className = 'af-button-close'
    ..style.cursor = 'pointer'
    ..style.fontSize = '0'
    ..append(SvgElement.svg('''
        <svg xmlns="http://www.w3.org/2000/svg" height="24" viewBox="0 0 24 24" width="24">
          <path d="M0 0h24v24H0z" fill="none"/>
          <path fill="#fff" d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
        </svg>
        '''));
  final SvgElement _icon;
  final dom.HeadingElement _heading;
  final dom.ParagraphElement _text;
  Timer? timer;

  int get toastCount =>
      dom.document.body?.querySelectorAll('div.af-toast-container').length ?? 0;

  factory Toast.error(
          {String title = 'Error',
          required String text,
          int width = 600,
          int padding = 12,
          int iconSize = 24,
          Duration? duration}) =>
      Toast._(
          title: title,
          text: text,
          width: width,
          padding: padding,
          iconSize: iconSize,
          duration: duration,
          alertLevel: AlertLevel.error);

  factory Toast.info(
          {String title = 'Information',
          required String text,
          int width = 600,
          int padding = 12,
          int iconSize = 24,
          Duration? duration}) =>
      Toast._(
          title: title,
          text: text,
          width: width,
          padding: padding,
          iconSize: iconSize,
          duration: duration,
          alertLevel: AlertLevel.info);

  factory Toast.success(
          {String title = 'Success',
          required String text,
          int width = 600,
          int padding = 12,
          int iconSize = 24,
          Duration? duration}) =>
      Toast._(
          title: title,
          text: text,
          width: width,
          padding: padding,
          iconSize: iconSize,
          duration: duration,
          alertLevel: AlertLevel.success);

  factory Toast.warning(
          {String title = 'Warning',
          required String text,
          int width = 600,
          int padding = 12,
          int iconSize = 24,
          Duration? duration}) =>
      Toast._(
          title: title,
          text: text,
          width: width,
          padding: padding,
          iconSize: iconSize,
          duration: duration,
          alertLevel: AlertLevel.warning);

  Toast._({
    this.alertLevel = AlertLevel.info,
    required String title,
    required String text,
    int width = 600,
    int padding = 12,
    int iconSize = 24,
    Duration? duration,
  })  : _heading = dom.HeadingElement.h2()
          ..className = 'af-heading'
          ..style.fontSize = '1.2rem'
          ..style.fontWeight = '600'
          ..style.margin = '0'
          ..style.overflow = 'hidden'
          ..style.textOverflow = 'ellipsis'
          ..style.whiteSpace = 'nowrap'
          ..innerText = title,
        _text = dom.ParagraphElement()
          ..className = 'af-text'
          ..styleMap?.set('all', 'initial')
          ..style.fontSize = '1rem'
          ..style.lineHeight = '1rem'
          ..style.margin = '0 0 0 8px'
          ..style.flex = '1'
          ..innerText = text,
        _icon = SvgElement.svg(properties[alertLevel]!.iconSVG)
          ..attributes['width'] = '$iconSize'
          ..attributes['height'] = '$iconSize' {
    final property = properties[alertLevel]!;
    _container
      ..classes = ['af-toast-container']
      ..style.position = 'fixed'
      ..style.zIndex = '${999 - toastCount}'
      ..style.bottom = '-100px'
      ..style.left = '0'
      ..style.width = '100vw'
      ..style.display = 'flex'
      ..style.justifyContent = 'center'
      ..style.transition = 'bottom 200ms ease, opacity 300ms ease';

    _content
      ..classes = ['af-toast', property.className]
      ..style.borderRadius = '4px'
      ..style.padding = '${padding}px'
      ..style.marginLeft = '${_toastMargin}px'
      ..style.marginRight = '${_toastMargin}px'
      ..style.width = '${width}px'
      ..style.backgroundColor = property.backgroundColor;

    final font = dom.document.body?.getComputedStyle().fontFamily;

    _heading.style.color = property.color;
    _closeButton.style.color = property.color;
    _text.style.color = property.color;
    _heading.style.fontFamily = font;
    _text.style.fontFamily = font;

    final titleRow = dom.DivElement()
      ..className = 'af-title'
      ..style.display = 'flex'
      ..style.alignItems = 'center'
      ..style.justifyContent = 'space-between'
      ..append(_heading)
      ..append(_closeButton);

    final textRow = dom.DivElement()
      ..className = 'af-text'
      ..style.marginTop = '8px'
      ..style.display = 'flex'
      ..style.alignItems = 'center'
      ..append(_icon)
      ..append(_text);

    _content..append(titleRow)..append(textRow);
    _container.append(_content);
    dom.document.body?.append(_container);

    if (dom.document.head?.querySelector('#af-toast-style') == null) {
      final css = dom.StyleElement()
        ..id = 'af-toast-style'
        ..innerHtml = '''
          div.af-title h2.af-heading {
            all: initial;
          }
          div.af-title div.af-button-close {
            all: initial;
          }
          div.af-text p.af-text {
            all: initial;
          }
        ''';
      dom.document.head?.children.add(css);
    }

    if (duration != null) {
      timer = Timer(duration, close);
    }

    _closeButton.onClick.first.then((_) => close());
    Future.delayed(const Duration(milliseconds: 10))
        .then((_) => evaluatePositions());
  }

  void close() async {
    timer?.cancel();
    _container.style.opacity = '0';
    await Future.delayed(const Duration(milliseconds: 300));
    _container.remove();
    evaluatePositions();
  }
}

void evaluatePositions() {
  final elements =
      dom.document.body?.querySelectorAll('div.af-toast-container');
  if (elements != null) {
    var bottom = _toastMargin;
    for (final element in elements) {
      element.style.bottom = '${bottom}px';
      bottom += _toastMargin + element.clientHeight;
    }
  }
}
