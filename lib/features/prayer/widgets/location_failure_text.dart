import '../../../core/errors/failures.dart';
import '../../../core/localization/generated/app_localizations.dart';

extension LocationFailureText on LocationFailure {
  String message(AppLocalizations l10n) => switch (this) {
        LocationFailure.serviceDisabled => l10n.locationErrorServiceDisabled,
        LocationFailure.permissionDenied => l10n.locationErrorDenied,
        LocationFailure.permissionDeniedForever => l10n.locationErrorDeniedForever,
        LocationFailure.timeout => l10n.locationErrorTimeout,
        LocationFailure.unknown => l10n.locationErrorUnknown,
      };
}
