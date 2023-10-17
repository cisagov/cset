import filenameReservedRegex, {windowsReservedNameRegex} from 'filename-reserved-regex';

export default function isValidFilename(string) {
	if (!string || string.length > 255) {
		return false;
	}

	if (filenameReservedRegex().test(string) || windowsReservedNameRegex().test(string)) {
		return false;
	}

	if (string === '.' || string === '..') {
		return false;
	}

	return true;
}
