enum AlertLevel { success, info, warning, error }

class AlertLevelProperties {
  final String backgroundColor;
  final String color;
  final String iconSVG;
  final String className;

  const AlertLevelProperties({
    required this.backgroundColor,
    required this.color,
    required this.iconSVG,
    required this.className,
  });
}

const Map<AlertLevel, AlertLevelProperties> properties = {
  AlertLevel.error: AlertLevelProperties(
    backgroundColor: '#E74851',
    color: '#fff',
    iconSVG: '''
        <svg xmlns="http://www.w3.org/2000/svg" height="24" viewBox="0 0 24 24" width="24">
          <path d="M0 0h24v24H0z" fill="none"/>
          <path fill="#fff" d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/>
        </svg>''',
    className: 'toast-error',
  ),
  AlertLevel.info: AlertLevelProperties(
    backgroundColor: '#264653',
    color: '#fff',
    iconSVG: '''
          <svg xmlns="http://www.w3.org/2000/svg" height="24" viewBox="0 0 24 24" width="24">
            <path d="M0 0h24v24H0z" fill="none" />
            <path fill="#fff" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/>
          </svg>''',
    className: 'toast-info',
  ),
  AlertLevel.success: AlertLevelProperties(
    backgroundColor: '#2A9D8F',
    color: '#fff',
    iconSVG: '''
        <svg xmlns="http://www.w3.org/2000/svg" height="24" viewBox="0 0 24 24" width="24">
          <path d="M0 0h24v24H0z" fill="none"/>
          <path fill="#fff" d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
        </svg>''',
    className: 'toast-success',
  ),
  AlertLevel.warning: AlertLevelProperties(
    backgroundColor: '#f87F62',
    color: '#fff',
    iconSVG: '''
        <svg xmlns="http://www.w3.org/2000/svg" height="24" viewBox="0 0 24 24" width="24">
          <path d="M0 0h24v24H0z" fill="none"/>
          <circle cx="12" cy="19" r="2" fill="#fff"/>
          <path d="M10 3h4v12h-4z" fill="#fff"/>
        </svg>''',
    className: 'toast-warning',
  ),
};
