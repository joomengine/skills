<?php
/**
 * @package    JCB.AiDoc.Examples
 * @license    CC0-1.0; see LICENSE
 */

namespace VDM\Joomla\SkillExample;

/**
 * Documentation fixture: replaceable server-side unit price boundary.
 *
 * @since 1.0.0
 */
interface UnitPriceProvider
{
	/**
	 * Return the current unit price in integer minor currency units.
	 *
	 * The caller selects one currency; missing variants must throw.
	 *
	 * @param   string  $sku  Exact product variant identifier.
	 * @return  int          Nonnegative minor-unit amount.
	 * @throws  \OutOfBoundsException  When the variant does not exist.
	 * @since   1.0.0
	 */
	public function unitPrice(string $sku): int;
}
