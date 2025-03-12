import http from 'k6/http';
import { check, sleep } from 'k6';
import { htmlReport } from 'https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js';
import { textSummary } from 'https://jslib.k6.io/k6-summary/0.0.1/index.js';
import { Trend } from 'k6/metrics';

// Read environment variables
const URL = __ENV.URL || 'https://test.k6.io';
const RAMP_UP = parseInt(__ENV.RAMP_UP || '15');
const STEADY_STATE = parseInt(__ENV.STEADY_STATE || '30');
const RAMP_DOWN = parseInt(__ENV.RAMP_DOWN || '15');
const VIRTUAL_USERS = parseInt(__ENV.VIRTUAL_USERS || '10');
const THRESHOLD_REQ_DURATION = parseInt(__ENV.THRESHOLD_REQ_DURATION || '1000');
const THRESHOLD_REQ_FAILED = parseFloat(__ENV.THRESHOLD_REQ_FAILED || '0.01');

// Custom metrics
const customMetrics = {
    responseTime: new Trend('response_time'),
};

export let options = {
    stages: [
        { duration: `${RAMP_UP}s`, target: VIRTUAL_USERS },
        { duration: `${STEADY_STATE}s`, target: VIRTUAL_USERS },
        { duration: `${RAMP_DOWN}s`, target: 0 },
    ],
    thresholds: {
        'http_req_failed': [`rate<${THRESHOLD_REQ_FAILED}`],
        'http_req_duration': [`p(95)<${THRESHOLD_REQ_DURATION}`],
        'response_time': [`avg<${THRESHOLD_REQ_DURATION}`],
    },
};

export default function () {
    const startTime = new Date().getTime();

    // Add a timestamp to avoid caching
    const testUrl = URL.includes('?')
        ? `${URL}&timestamp=${startTime}`
        : `${URL}?timestamp=${startTime}`;

    let response = http.get(testUrl);

    const endTime = new Date().getTime();
    const duration = endTime - startTime;
    customMetrics.responseTime.add(duration);

    check(response, {
        'is status 200': (r) => r.status === 200,
    `transaction time < ${THRESHOLD_REQ_DURATION}ms`: (r) => r.timings.duration < THRESHOLD_REQ_DURATION,
  });

sleep(1);
}

export function handleSummary(data) {
    const timestamp = new Date().toISOString().replace(/:/g, '-');
    return {
        [`summary-${timestamp}.html`]: htmlReport(data),
        [`summary-${timestamp}.json`]: JSON.stringify(data),
        'stdout': textSummary(data, { indent: ' ', enableColors: true }),
    };
}
