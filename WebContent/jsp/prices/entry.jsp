<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Price | AgriMarket Tracker</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f4f0; color: #333;
        }

        nav {
            background: #2e7d32; padding: 0 24px;
            display: flex; align-items: center; justify-content: space-between;
            height: 56px; box-shadow: 0 2px 6px rgba(0,0,0,0.25);
        }
        nav .brand { color: #fff; font-size: 1.2rem; font-weight: 700; text-decoration: none; }
        nav ul { list-style: none; display: flex; gap: 4px; }
        nav ul li a {
            color: #c8e6c9; text-decoration: none; padding: 8px 14px;
            border-radius: 4px; font-size: 0.9rem; transition: background 0.2s;
        }
        nav ul li a:hover, nav ul li a.active { background: #1b5e20; color: #fff; }

        .page-wrapper { max-width: 640px; margin: 40px auto; padding: 0 16px; }

        .page-title {
            font-size: 1.6rem; color: #2e7d32; margin-bottom: 24px;
            font-weight: 700; border-left: 5px solid #66bb6a; padding-left: 12px;
        }

        .form-card {
            background: #fff; border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 32px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block; font-size: 0.88rem; font-weight: 600;
            color: #444; margin-bottom: 6px;
        }

        .form-group label .required {
            color: #c62828; margin-left: 3px;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%; padding: 10px 14px;
            border: 1px solid #ccc; border-radius: 6px;
            font-size: 0.9rem; font-family: inherit;
            outline: none; transition: border-color 0.2s, box-shadow 0.2s;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: #2e7d32;
            box-shadow: 0 0 0 3px rgba(46,125,50,0.12);
        }

        .form-group input.error,
        .form-group select.error,
        .form-group textarea.error {
            border-color: #c62828;
            box-shadow: 0 0 0 3px rgba(198,40,40,0.1);
        }

        .form-group textarea {
            resize: vertical; min-height: 90px;
        }

        .error-msg {
            color: #c62828; font-size: 0.8rem;
            margin-top: 5px; display: none;
        }
        .error-msg.visible { display: block; }

        .form-row {
            display: grid; grid-template-columns: 1fr 1fr; gap: 16px;
        }

        .form-actions {
            display: flex; gap: 12px; justify-content: flex-end;
            margin-top: 24px; padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .btn {
            padding: 10px 24px; border: none; border-radius: 6px;
            cursor: pointer; font-size: 0.9rem; font-weight: 600;
            transition: background 0.2s, transform 0.1s;
        }
        .btn:active { transform: scale(0.97); }
        .btn-primary { background: #2e7d32; color: #fff; }
        .btn-primary:hover { background: #1b5e20; }
        .btn-secondary { background: #e0e0e0; color: #333; }
        .btn-secondary:hover { background: #bdbdbd; }

        /* Success toast */
        .toast {
            position: fixed; bottom: 30px; right: 30px;
            background: #2e7d32; color: #fff;
            padding: 14px 22px; border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            font-size: 0.9rem; font-weight: 600;
            transform: translateY(80px); opacity: 0;
            transition: all 0.35s ease;
            z-index: 999;
        }
        .toast.show { transform: translateY(0); opacity: 1; }

        .form-hint { font-size: 0.78rem; color: #999; margin-top: 4px; }
    </style>
</head>
<body>

<nav>
    <a href="../index.jsp" class="brand">🌾 AgriMarket Tracker</a>
    <ul>
        <li><a href="list.jsp">Price List</a></li>
        <li><a href="compare.jsp">Compare</a></li>
        <li><a href="entry.jsp" class="active">Add Price</a></li>
        <li><a href="history.jsp">History</a></li>
        <li><a href="../trends/trends.jsp">Trends</a></li>
    </ul>
</nav>

<div class="page-wrapper">
    <h1 class="page-title">Enter Agricultural Price</h1>

    <div class="form-card">
        <form id="priceForm" novalidate onsubmit="handleSubmit(event)">

            <!-- Market & Product -->
            <div class="form-row">
                <div class="form-group">
                    <label for="market">Market <span class="required">*</span></label>
                    <select id="market" name="market">
                        <option value="">-- Select Market --</option>
                        <option value="Nairobi Market">Nairobi Market</option>
                        <option value="Mombasa Market">Mombasa Market</option>
                        <option value="Kisumu Market">Kisumu Market</option>
                        <option value="Nakuru Market">Nakuru Market</option>
                        <option value="Eldoret Market">Eldoret Market</option>
                        <option value="Machakos Market">Machakos Market</option>
                        <option value="Other">Other</option>
                    </select>
                    <span class="error-msg" id="err-market">Please select a market.</span>
                </div>

                <div class="form-group">
                    <label for="product">Product <span class="required">*</span></label>
                    <select id="product" name="product">
                        <option value="">-- Select Product --</option>
                        <option value="Maize">Maize</option>
                        <option value="Wheat">Wheat</option>
                        <option value="Rice">Rice</option>
                        <option value="Sorghum">Sorghum</option>
                        <option value="Beans">Beans</option>
                        <option value="Potatoes">Potatoes</option>
                        <option value="Tomatoes">Tomatoes</option>
                        <option value="Onions">Onions</option>
                        <option value="Cabbage">Cabbage</option>
                        <option value="Other">Other</option>
                    </select>
                    <span class="error-msg" id="err-product">Please select a product.</span>
                </div>
            </div>

            <!-- Price & Date -->
            <div class="form-row">
                <div class="form-group">
                    <label for="price">Price (KES/kg) <span class="required">*</span></label>
                    <input type="text" id="price" name="price" placeholder="e.g. 45.50">
                    <span class="form-hint">Enter price per kilogram in Kenya Shillings.</span>
                    <span class="error-msg" id="err-price">Price is required and must be a valid positive number.</span>
                </div>

                <div class="form-group">
                    <label for="pdate">Date <span class="required">*</span></label>
                    <input type="date" id="pdate" name="pdate">
                    <span class="error-msg" id="err-pdate">Please select a date.</span>
                </div>
            </div>

            <!-- Notes -->
            <div class="form-group">
                <label for="notes">Notes</label>
                <textarea id="notes" name="notes" placeholder="Optional: quality grade, source, remarks..."></textarea>
            </div>

            <!-- Actions -->
            <div class="form-actions">
                <button type="button" class="btn btn-secondary" onclick="resetForm()">Reset</button>
                <button type="submit" class="btn btn-primary">💾 Save Price</button>
            </div>
        </form>
    </div>
</div>

<!-- Toast notification -->
<div class="toast" id="toast">✅ Price saved successfully!</div>

<script>
    // ── Set today's date as default ──────────────────
    document.getElementById('pdate').value = new Date().toISOString().split('T')[0];

    // ── Validation helpers ───────────────────────────
    function showError(fieldId, msgId, show) {
        const field = document.getElementById(fieldId);
        const msg   = document.getElementById(msgId);
        if (show) {
            field.classList.add('error');
            msg.classList.add('visible');
        } else {
            field.classList.remove('error');
            msg.classList.remove('visible');
        }
        return !show;
    }

    function isPositiveNumber(val) {
        return /^\d+(\.\d+)?$/.test(val.trim()) && parseFloat(val.trim()) > 0;
    }

    function validateForm() {
        let valid = true;

        // Market
        const market = document.getElementById('market').value;
        if (!showError('market', 'err-market', market === '')) valid = false;

        // Product
        const product = document.getElementById('product').value;
        if (!showError('product', 'err-product', product === '')) valid = false;

        // Price
        const price = document.getElementById('price').value;
        if (!showError('price', 'err-price', !isPositiveNumber(price))) valid = false;

        // Date
        const pdate = document.getElementById('pdate').value;
        if (!showError('pdate', 'err-pdate', pdate === '')) valid = false;

        return valid;
    }

    // ── Clear errors on input ────────────────────────
    ['market','product','price','pdate'].forEach(id => {
        document.getElementById(id).addEventListener('change', () => validateForm());
        document.getElementById(id).addEventListener('input',  () => validateForm());
    });

    // ── Submit handler ───────────────────────────────
    function handleSubmit(e) {
        e.preventDefault();
        if (!validateForm()) return;

        // In a real app you'd POST to a servlet here.
        // For demo, we just show the toast.
        showToast();
        resetForm();
    }

    function resetForm() {
        document.getElementById('priceForm').reset();
        document.getElementById('pdate').value = new Date().toISOString().split('T')[0];
        ['market','product','price','pdate'].forEach(id => {
            document.getElementById(id).classList.remove('error');
        });
        document.querySelectorAll('.error-msg').forEach(el => el.classList.remove('visible'));
    }

    function showToast() {
        const toast = document.getElementById('toast');
        toast.classList.add('show');
        setTimeout(() => toast.classList.remove('show'), 3000);
    }
</script>
</body>
</html>