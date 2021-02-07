import 'dart:async';
import 'dart:html' as dom;
import 'dart:svg';

import 'alert_level_properties.dart';

class Toast {
  final AlertLevel alertLevel;

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
      dom.document.body?.querySelectorAll('div.af-toast').length ?? 0;

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
          ..style.margin = '0'
          ..style.overflow = 'hidden'
          ..style.textOverflow = 'ellipsis'
          ..style.whiteSpace = 'nowrap'
          ..innerText = title,
        _text = dom.ParagraphElement()
          ..className = 'af-text'
          ..style.margin = '0 0 0 8px'
          ..style.flex = '1'
          ..innerText = text,
        _icon = SvgElement.svg(properties[alertLevel]!.iconSVG)
          ..attributes['width'] = '$iconSize'
          ..attributes['height'] = '$iconSize' {
    final property = properties[alertLevel]!;
    _content
      ..classes = ['af-toast', property.className]
      ..style.transition = 'bottom 300ms ease, opacity 300ms ease'
      ..style.borderRadius = '4px'
      ..style.padding = '${padding}px'
      ..style.position = 'fixed'
      ..style.zIndex = '${999 - toastCount}'
      ..style.bottom = '-100px'
      ..style.width = '${width}px'
      ..style.marginLeft = '${-0.5 * width}px'
      ..style.left = '50%'
      ..style.backgroundColor = property.backgroundColor
      ..style.color = property.color;

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
    dom.document.body?.append(_content);

    if (duration != null) {
      timer = Timer(duration, close);
    }

    _closeButton.onClick.first.then((_) => close());
    Future.delayed(const Duration(milliseconds: 10))
        .then((_) => _evaluatePositions(margin: 4));
  }

  void close() async {
    timer?.cancel();
    _content.style.opacity = '0';
    await Future.delayed(const Duration(milliseconds: 300));
    _content.remove();
    _evaluatePositions(margin: 4);
  }

  void _evaluatePositions({required int margin}) {
    final elements = dom.document.body?.querySelectorAll('div.af-toast');
    if (elements != null) {
      var bottom = margin;
      for (final element in elements) {
        element.style.bottom = '${bottom}px';
        bottom += margin + element.clientHeight;
      }
    }
  }
}
