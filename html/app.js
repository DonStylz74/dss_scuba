window.addEventListener("message", (event) => {
    const data = event.data;

    if (data.action === "showOxygen") {

        // Show the gauge UI
        const container = document.getElementById("dualGaugeContainer");
        container.style.display = "block";

        const percent = Number(data.percent) || 0;
        const depth = Number(data.depth) || 0;

        const oxygenRing = document.querySelector(".bar");
        const depthRing = document.querySelector(".depthRing");

        const oxygenText = document.getElementById("oxygenText");
        const depthText = document.getElementById("depthText");

        // =====================================================
        // OXYGEN
        // =====================================================

        const offset = 283 - (283 * percent / 100);

        oxygenRing.style.strokeDashoffset = offset;

        oxygenText.innerText = `${percent}%`;

        // Normal oxygen = invisible ring + white text
        if (percent > 25) {

            oxygenRing.style.stroke = "transparent";
            oxygenText.style.color = "white";

        // 25% or lower = yellow
        } else if (percent > 10) {

            oxygenRing.style.stroke = "#ffcc00";
            oxygenText.style.color = "#ffcc00";

        // 10% or lower = red
        } else {

            oxygenRing.style.stroke = "#ff0000";
            oxygenText.style.color = "#ff0000";
        }


        // =====================================================
        // DEPTH
        // =====================================================

        depthText.innerText = `${depth}m`;

        // Normal depth = invisible ring + white text
        if (depth > -100) {

            depthRing.style.stroke = "transparent";
            depthText.style.color = "white";

        // -100m to -174m = yellow
        } else if (depth > -175) {

            depthRing.style.stroke = "#ffcc00";
            depthText.style.color = "#ffcc00";

        // -175m or deeper = red
        } else {

            depthRing.style.stroke = "#ff0000";
            depthText.style.color = "#ff0000";
        }
    }

    if (data.action === "hideOxygen") {
        document.getElementById("dualGaugeContainer").style.display = "none";
    }
});