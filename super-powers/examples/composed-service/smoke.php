<?php
/** @license CC0-1.0; see LICENSE */
declare(strict_types=1);

require __DIR__ . '/src/20d6e122-d419-4f2d-acfb-a5c1819fc2d1/code.php';
require __DIR__ . '/src/06847141-791d-4482-8640-fc8bf1bf9037/code.php';

use VDM\Joomla\SkillExample\LineTotal;
use VDM\Joomla\SkillExample\UnitPriceProvider;

$prices = new class implements UnitPriceProvider {
	public function unitPrice(string $sku): int
	{
		return match ($sku) {
			'TSHIRT-BLUE-M' => 19995,
			'FREE' => 0,
			'NEGATIVE' => -1,
			'MAXIMUM' => PHP_INT_MAX,
			default => throw new \OutOfBoundsException('Unknown variant: ' . $sku),
		};
	}
};

$service = new LineTotal($prices);
$cases = 0;
foreach ([['TSHIRT-BLUE-M', 3, 59985], ['FREE', PHP_INT_MAX, 0], ['MAXIMUM', 1, PHP_INT_MAX]] as [$sku, $quantity, $expected])
{
	if ($service->calculate($sku, $quantity) !== $expected)
	{
		throw new \RuntimeException('Unexpected total for ' . $sku);
	}
	$cases++;
}

foreach ([
	['', 1, \InvalidArgumentException::class],
	['  ', 1, \InvalidArgumentException::class],
	['TSHIRT-BLUE-M', 0, \InvalidArgumentException::class],
	['TSHIRT-BLUE-M', -1, \InvalidArgumentException::class],
	['UNKNOWN', 1, \OutOfBoundsException::class],
	['NEGATIVE', 1, \UnexpectedValueException::class],
	['MAXIMUM', 2, \OverflowException::class],
] as [$sku, $quantity, $expectedException])
{
	try
	{
		$service->calculate($sku, $quantity);
	}
	catch (\Throwable $exception)
	{
		if (!($exception instanceof $expectedException))
		{
			throw new \RuntimeException('Unexpected exception type.', 0, $exception);
		}
		$cases++;
		continue;
	}
	throw new \RuntimeException('Expected exception was not thrown: ' . $expectedException);
}

echo "Composed service: {$cases} behaviour checks passed.\n";
