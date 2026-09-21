(() => {
	const splashScreen = document.getElementById('splash-screen');
	const mainContent = document.getElementById('main-content');

	if (!splashScreen || !mainContent) return;

	document.addEventListener('DOMContentLoaded', () => {
		window.setTimeout(() => {
			mainContent.classList.remove('hidden');
			splashScreen.classList.add('fade-out');

			window.setTimeout(() => {
				splashScreen.style.display = 'none';
			}, 800);
		}, 3200);
	});
})();
